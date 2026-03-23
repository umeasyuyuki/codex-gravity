/**
 * 全リンク済みシートに新しいタブを作成し、データを移行してDBの紐付けを更新
 *
 * エントリポイント:
 *   migrateAllSheets()    : 全シートを移行（本番実行）
 *   dryRunMigration()     : 変更内容のプレビューのみ（書き込みなし）
 *
 * 処理フロー:
 *   1. company-sheets APIから全リンク済みシートを取得
 *   2. 各スプレッドシートで:
 *      - 現在のタブからデータを読み取り
 *      - 新しいタブ「応募者一覧」を作成
 *      - 目標構造のヘッダー・書式を設定
 *      - 旧データを列名マッピングで新タブに書き込み
 *   3. DBの紐付けGIDを新タブのGIDに一括更新
 *
 * Script Properties (db_to_spreadsheet_sync_v2.gsと共通):
 *   RPO_API_URL
 *   RPO_API_KEY
 *   RPO_COMPANY_SHEETS_API_URL (省略時はRPO_API_URLから推定)
 */

/* ==========================
 * 目標ヘッダー定義（A-X列）
 * ========================== */
var MIGRATE_TARGET_HEADERS = [
  '応募日',              // A (1)
  '会社名',              // B (2)
  '案件名',              // C (3)
  '氏名',                // D (4)
  'mail',                // E (5)
  '応募職種名',          // F (6)
  '勤務地',              // G (7)
  '電話番号',            // H (8)
  '年齢',                // I (9)
  '生年月日',            // J (10)
  '性別',                // K (11)
  '担当者名',            // L (12)
  '有効応募',            // M (13)
  '対応状況',            // N (14)
  '備考',                // O (15)
  '次回アクション日',    // P (16)
  '連電日',              // Q (17)
  '面接予定日',          // R (18)
  '実施可否',            // S (19)
  '二次/最終面接予定日', // T (20)
  '二次/最終実施可否',   // U (21)
  '内定可否',            // V (22)
  '入社日',              // W (23)
  '_applicant_id',       // X (24) — hidden key
];

var MIGRATE_TOTAL_COLS = MIGRATE_TARGET_HEADERS.length; // 24
var MIGRATE_CHECKBOX_COLS = [13, 19, 21, 22]; // M, S, U, V (1-based)
var MIGRATE_DATE_COLS = [1, 10, 16, 17, 18, 20, 23]; // A, J, P, Q, R, T, W
var NEW_TAB_NAME = '応募者一覧';

// 旧ヘッダー名 → 新ヘッダー名のエイリアス
var HEADER_ALIASES = {
  '通電日': '連電日',
};

/* ==========================
 * エントリポイント
 * ========================== */

function migrateAllSheets() {
  return runMigration_({ dryRun: false });
}

function dryRunMigration() {
  return runMigration_({ dryRun: true });
}

/* ==========================
 * メイン処理
 * ========================== */

function runMigration_(opts) {
  var dryRun = opts.dryRun;
  var startTime = Date.now();

  // 1. company-sheets APIからシート一覧を取得
  var sheets = fetchSheetList_();
  Logger.log('[MIGRATE] 対象シート数: ' + sheets.length + (dryRun ? ' (DRY RUN)' : ''));

  for (var g = 0; g < sheets.length; g++) {
    Logger.log('[INFO] シート' + g + ': id=' + sheets[g].id + ' spreadsheet=' + sheets[g].spreadsheetId + ' gid=' + sheets[g].gid + ' company=' + sheets[g].companyName);
  }

  var summary = { total: sheets.length, success: 0, skipped: 0, failed: 0 };
  var gidUpdates = []; // {id, gid} — DB更新用

  for (var i = 0; i < sheets.length; i++) {
    if ((Date.now() - startTime) > 5 * 60 * 1000) {
      Logger.log('[WARN] 時間制限のため残り ' + (sheets.length - i) + ' 件をスキップ');
      break;
    }

    var entry = sheets[i];
    try {
      var result = migrateOneSheet_(entry, dryRun);
      Logger.log('[' + result.status.toUpperCase() + '] ' + entry.companyName + ' (' + entry.spreadsheetId + ') — ' + result.message);

      if (result.status === 'success' && result.newGid !== undefined) {
        summary.success++;
        gidUpdates.push({ id: entry.id, gid: result.newGid });
      } else if (result.status === 'skipped') {
        summary.skipped++;
      }
    } catch (e) {
      summary.failed++;
      Logger.log('[ERROR] ' + entry.companyName + ' (' + entry.spreadsheetId + '): ' + migrateErrMsg_(e));
    }
  }

  // 3. DBの紐付けGIDを一括更新
  if (!dryRun && gidUpdates.length > 0) {
    Logger.log('[INFO] DBのGIDを ' + gidUpdates.length + ' 件更新します...');
    try {
      updateSheetGidsInDb_(gidUpdates);
      Logger.log('[INFO] DB更新完了');
    } catch (e) {
      Logger.log('[ERROR] DB更新失敗: ' + migrateErrMsg_(e));
    }
  } else if (dryRun && gidUpdates.length > 0) {
    Logger.log('[DRYRUN] DB更新予定: ' + gidUpdates.length + ' 件');
    for (var u = 0; u < gidUpdates.length; u++) {
      Logger.log('  id=' + gidUpdates[u].id + ' → newGid=' + gidUpdates[u].gid);
    }
  }

  Logger.log(JSON.stringify({ mode: dryRun ? 'dryRun' : 'migrate', summary: summary }, null, 2));
  return summary;
}

/* ==========================
 * 1シートのマイグレーション
 * ========================== */

function migrateOneSheet_(entry, dryRun) {
  var spreadsheetId = entry.spreadsheetId;
  var oldGid = entry.gid;

  var ss = SpreadsheetApp.openById(spreadsheetId);
  var allTabs = ss.getSheets();

  // 全タブのログ
  Logger.log('[DEBUG] ' + entry.companyName + ' のタブ一覧:');
  for (var t = 0; t < allTabs.length; t++) {
    Logger.log('  "' + allTabs[t].getName() + '" GID=' + allTabs[t].getSheetId());
  }

  // 旧タブを探す
  var oldSheet = null;
  for (var i = 0; i < allTabs.length; i++) {
    if (allTabs[i].getSheetId() === oldGid) {
      oldSheet = allTabs[i];
      break;
    }
  }

  // 旧タブが見つからない場合、最初のタブをフォールバック
  if (!oldSheet) {
    Logger.log('[WARN] GID=' + oldGid + ' が見つからないため最初のタブを使用');
    oldSheet = allTabs[0];
  }

  var oldSheetName = oldSheet.getName();
  Logger.log('[DEBUG] 旧タブ: "' + oldSheetName + '" GID=' + oldSheet.getSheetId());

  // 既に「応募者一覧」タブが存在し、目標構造なら スキップ
  var existingNewTab = null;
  for (var j = 0; j < allTabs.length; j++) {
    if (allTabs[j].getName() === NEW_TAB_NAME && allTabs[j].getSheetId() !== oldSheet.getSheetId()) {
      existingNewTab = allTabs[j];
      break;
    }
  }

  if (existingNewTab) {
    var existingHeaders = existingNewTab.getRange(1, 1, 1, MIGRATE_TOTAL_COLS).getValues()[0];
    var match = true;
    for (var h = 0; h < MIGRATE_TARGET_HEADERS.length; h++) {
      if (String(existingHeaders[h] || '') !== MIGRATE_TARGET_HEADERS[h]) {
        match = false;
        break;
      }
    }
    if (match) {
      return { status: 'skipped', message: '"' + NEW_TAB_NAME + '" タブが既に存在し目標構造です (GID=' + existingNewTab.getSheetId() + ')', newGid: existingNewTab.getSheetId() };
    }
  }

  // 旧タブからデータ読み取り
  var lastCol = oldSheet.getLastColumn();
  var lastRow = oldSheet.getLastRow();
  var oldHeaders = [];
  var oldData = [];

  if (lastCol > 0 && lastRow >= 1) {
    oldHeaders = oldSheet.getRange(1, 1, 1, lastCol).getValues()[0];
  }
  if (lastCol > 0 && lastRow >= 2) {
    oldData = oldSheet.getRange(2, 1, lastRow - 1, lastCol).getValues();
  }

  Logger.log('[DEBUG] 旧ヘッダー: ' + oldHeaders.slice(0, 10).map(function(h) { return '"' + h + '"'; }).join(', '));
  Logger.log('[DEBUG] データ行数: ' + oldData.length);

  // 列マッピング構築
  var oldColMap = {};
  for (var c = 0; c < oldHeaders.length; c++) {
    var hdr = String(oldHeaders[c] || '').trim();
    if (hdr) oldColMap[hdr] = c;
  }

  var mapping = [];
  var mappingLog = [];
  for (var n = 0; n < MIGRATE_TARGET_HEADERS.length; n++) {
    var targetName = MIGRATE_TARGET_HEADERS[n];
    var oldIdx = -1;

    if (oldColMap.hasOwnProperty(targetName)) {
      oldIdx = oldColMap[targetName];
    }
    if (oldIdx === -1) {
      for (var alias in HEADER_ALIASES) {
        if (HEADER_ALIASES[alias] === targetName && oldColMap.hasOwnProperty(alias)) {
          oldIdx = oldColMap[alias];
          break;
        }
      }
    }

    mapping.push(oldIdx);
    if (oldIdx >= 0) {
      var oldName = String(oldHeaders[oldIdx] || '');
      if (oldName !== targetName) {
        mappingLog.push('  列' + (n + 1) + ' ' + targetName + ' ← 旧「' + oldName + '」');
      }
    } else {
      mappingLog.push('  列' + (n + 1) + ' ' + targetName + ' ← (新規)');
    }
  }

  // データ変換
  var newData = [];
  for (var r = 0; r < oldData.length; r++) {
    var newRow = [];
    for (var nc = 0; nc < MIGRATE_TOTAL_COLS; nc++) {
      var srcIdx = mapping[nc];
      if (srcIdx >= 0 && srcIdx < oldData[r].length) {
        newRow.push(oldData[r][srcIdx]);
      } else {
        newRow.push('');
      }
    }
    newData.push(newRow);
  }

  if (dryRun) {
    var msg = '旧タブ"' + oldSheetName + '"から新タブ"' + NEW_TAB_NAME + '"を作成予定 (' + oldData.length + '行)';
    if (mappingLog.length > 0) msg += '\n' + mappingLog.join('\n');
    return { status: 'success', message: '[DRY RUN] ' + msg, newGid: 0 };
  }

  // === 本番実行 ===

  // 既存の同名タブがあれば削除
  if (existingNewTab) {
    ss.deleteSheet(existingNewTab);
  }

  // 新しいタブを作成
  var newSheet = ss.insertSheet(NEW_TAB_NAME);
  var newGid = newSheet.getSheetId();
  Logger.log('[INFO] 新タブ作成: "' + NEW_TAB_NAME + '" GID=' + newGid);

  // 列数を確保
  var currentCols = newSheet.getMaxColumns();
  if (currentCols < MIGRATE_TOTAL_COLS) {
    newSheet.insertColumnsAfter(currentCols, MIGRATE_TOTAL_COLS - currentCols);
  } else if (currentCols > MIGRATE_TOTAL_COLS) {
    newSheet.deleteColumns(MIGRATE_TOTAL_COLS + 1, currentCols - MIGRATE_TOTAL_COLS);
  }

  // ヘッダー書き込み
  newSheet.getRange(1, 1, 1, MIGRATE_TOTAL_COLS).setValues([MIGRATE_TARGET_HEADERS]);

  // データ書き込み
  if (newData.length > 0) {
    // 行数を確保
    var currentRows = newSheet.getMaxRows();
    var neededRows = newData.length + 1; // +1 for header
    if (currentRows < neededRows) {
      newSheet.insertRowsAfter(currentRows, neededRows - currentRows);
    }

    newSheet.getRange(2, 1, newData.length, MIGRATE_TOTAL_COLS).setValues(newData);

    // チェックボックス設定
    var cbRule = SpreadsheetApp.newDataValidation().requireCheckbox().build();
    for (var cb = 0; cb < MIGRATE_CHECKBOX_COLS.length; cb++) {
      newSheet.getRange(2, MIGRATE_CHECKBOX_COLS[cb], newData.length, 1).setDataValidation(cbRule);
    }

    // 日付フォーマット
    for (var dc = 0; dc < MIGRATE_DATE_COLS.length; dc++) {
      newSheet.getRange(2, MIGRATE_DATE_COLS[dc], newData.length, 1).setNumberFormat('yyyy-mm-dd');
    }
  }

  // X列を非表示
  newSheet.hideColumns(MIGRATE_TOTAL_COLS);

  // 新タブを先頭に移動
  ss.setActiveSheet(newSheet);
  ss.moveActiveSheet(1);

  var resultMsg = '新タブ"' + NEW_TAB_NAME + '"(GID=' + newGid + ')を作成、' + newData.length + '行を移行完了';
  if (mappingLog.length > 0) resultMsg += ' (列変更' + mappingLog.length + '件)';

  return { status: 'success', message: resultMsg, newGid: newGid };
}

/* ==========================
 * API通信
 * ========================== */

function fetchSheetList_() {
  var url = getMigrateCompanySheetsUrl_();
  var apiKey = getMigrateProp_('RPO_API_KEY');
  if (!url || !apiKey) throw new Error('RPO_API_URL / RPO_API_KEY が未設定です');

  var response = UrlFetchApp.fetch(url, {
    method: 'get',
    headers: { 'x-rpo-api-key': apiKey },
    muteHttpExceptions: true,
  });

  var status = response.getResponseCode();
  if (status < 200 || status >= 300) {
    throw new Error('company-sheets API error (' + status + '): ' + response.getContentText().slice(0, 300));
  }

  var body = JSON.parse(response.getContentText());
  var rawSheets = (body.data && body.data.sheets) ? body.data.sheets : [];

  // 全シートを返す（spreadsheetId+gidが重複する場合もidが違うので全部返す）
  var result = [];
  for (var i = 0; i < rawSheets.length; i++) {
    var s = rawSheets[i];
    if (!s.spreadsheetId) continue;
    result.push({
      id: s.id,
      spreadsheetId: s.spreadsheetId,
      gid: s.gid || 0,
      companyName: s.companyName || '',
    });
  }
  return result;
}

function updateSheetGidsInDb_(updates) {
  var baseUrl = getMigrateProp_('RPO_API_URL');
  if (!baseUrl) throw new Error('RPO_API_URL が未設定です');
  var apiKey = getMigrateProp_('RPO_API_KEY');

  // /api/sync/applicants → /api/admin/update-sheet-gids
  var url = baseUrl.replace(/\/api\/sync\/applicants\b/, '/api/admin/update-sheet-gids');

  var response = UrlFetchApp.fetch(url, {
    method: 'post',
    contentType: 'application/json',
    headers: { 'x-rpo-api-key': apiKey },
    payload: JSON.stringify({ updates: updates }),
    muteHttpExceptions: true,
  });

  var status = response.getResponseCode();
  var text = response.getContentText();
  if (status < 200 || status >= 300) {
    throw new Error('update-sheet-gids API error (' + status + '): ' + text.slice(0, 300));
  }

  var body = JSON.parse(text);
  Logger.log('[INFO] DB更新結果: ' + JSON.stringify(body));
  return body;
}

function getMigrateCompanySheetsUrl_() {
  var explicit = getMigrateProp_('RPO_COMPANY_SHEETS_API_URL');
  if (explicit) return explicit;
  var base = getMigrateProp_('RPO_API_URL');
  if (!base) return '';
  return base.replace(/\/api\/sync\/applicants\b/, '/api/sync/company-sheets');
}

function getMigrateProp_(key) {
  return (PropertiesService.getScriptProperties().getProperty(key) || '').trim();
}

function migrateErrMsg_(e) {
  if (!e) return 'unknown error';
  if (e instanceof Error) return e.stack || e.message || String(e);
  return String(e);
}
