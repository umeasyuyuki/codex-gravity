/**
 * 全企業の候補者管理シートを同一スプレッドシート内で複製し、結果をログ出力する
 *
 * エントリポイント:
 *   - duplicateAllSheets()  : 本番実行（シート複製）
 *   - dryRunDuplicateAll()  : 検証（複製せずログのみ）
 *
 * Script Properties:
 *   RPO_API_URL   (例: https://rpo-app.yukipono-rpo.workers.dev/api/sync/applicants)
 *   RPO_API_KEY
 */

var DUP_CONFIG = {
  newSheetSuffix: '_RPO同期用',
  api: {
    maxRetries: 3,
    retryBaseSleepMs: 800,
  },
};

/* ==========================
 * エントリポイント
 * ========================== */

function duplicateAllSheets() {
  return DuplicateApp_.run({ dryRun: false });
}

function dryRunDuplicateAll() {
  return DuplicateApp_.run({ dryRun: true });
}

/**
 * 特定のスプレッドシートIDを指定して1件だけ複製する
 * 使い方: duplicateOneSheet('スプレッドシートID') を実行
 *   または下の duplicateOsakaKiki() のように個別関数を作る
 */
function duplicateOneSheet(spreadsheetId, sourceGid) {
  return DuplicateApp_.runOne(spreadsheetId, sourceGid || 465742923);
}

/** 株式会社大阪機器工作所（失敗分リトライ用） */
function duplicateOsakaKiki() {
  return duplicateOneSheet('1eVO3Ix9o08M17w87wOdJiOLfd668oEXjfKbpcnmm-J0', 465742923);
}

/* ==========================
 * メイン処理
 * ========================== */

var DuplicateApp_ = (function () {
  function run(opts) {
    var dryRun = opts.dryRun;
    Logger.log('=== シート複製 ' + (dryRun ? '(DRY RUN)' : '(本番)') + ' 開始 ===');

    var sheets = fetchCompanySheets_();
    Logger.log('取得したシート設定数: ' + sheets.length);

    // (spreadsheetId, gid) でグループ化
    var groups = groupBySpreadsheetAndGid_(sheets);
    Logger.log('ユニークな (spreadsheetId, gid) グループ数: ' + groups.length);

    var results = [];
    var successCount = 0;
    var failCount = 0;

    for (var i = 0; i < groups.length; i++) {
      var group = groups[i];
      var companyNames = group.companies.join(', ');

      if (dryRun) {
        Logger.log('[DRYRUN] 対象: ' + companyNames);
        Logger.log('[DRYRUN]   spreadsheetId: ' + group.spreadsheetId);
        Logger.log('[DRYRUN]   現在のGID: ' + group.gid);
        results.push({
          spreadsheetId: group.spreadsheetId,
          companies: companyNames,
          oldGid: group.gid,
          newGid: '(dryRun)',
          newSheetName: '(dryRun)',
          status: 'DRYRUN',
        });
        continue;
      }

      try {
        var result = duplicateSheet_(group.spreadsheetId, group.gid);
        successCount++;
        results.push({
          spreadsheetId: group.spreadsheetId,
          companies: companyNames,
          oldGid: group.gid,
          newGid: result.newGid,
          newSheetName: result.newSheetName,
          status: 'OK',
        });
      } catch (e) {
        failCount++;
        var errMsg = e && e.message ? e.message : String(e);
        results.push({
          spreadsheetId: group.spreadsheetId,
          companies: companyNames,
          oldGid: group.gid,
          newGid: '',
          newSheetName: '',
          status: 'ERROR: ' + errMsg,
        });
      }
    }

    // === 結果ログ出力 ===
    Logger.log('');
    Logger.log('========================================');
    Logger.log('  複製結果一覧  (' + (dryRun ? 'DRY RUN' : '本番') + ')');
    Logger.log('========================================');
    Logger.log('成功: ' + successCount + ' / 失敗: ' + failCount + ' / 合計: ' + groups.length);
    Logger.log('');

    // ヘッダー
    Logger.log('企業名\tspreadsheetId\t旧GID\t新GID\t新シート名\tステータス');
    Logger.log('---');

    for (var j = 0; j < results.length; j++) {
      var r = results[j];
      Logger.log(
        r.companies + '\t' +
        r.spreadsheetId + '\t' +
        r.oldGid + '\t' +
        r.newGid + '\t' +
        r.newSheetName + '\t' +
        r.status
      );
    }

    Logger.log('');
    Logger.log('=== 完了 ===');

    // UI上で更新しやすいようにコピペ用一覧も出力
    Logger.log('');
    Logger.log('========================================');
    Logger.log('  管理画面更新用：spreadsheetId → 新GID');
    Logger.log('========================================');
    for (var k = 0; k < results.length; k++) {
      var r2 = results[k];
      if (r2.status === 'OK') {
        Logger.log(r2.companies);
        Logger.log('  新GID: ' + r2.newGid + '  シート名: ' + r2.newSheetName);
      }
    }

    return results;
  }

  /* --- API --- */

  function fetchCompanySheets_() {
    var apiUrl = getProp_('RPO_API_URL');
    var apiKey = getProp_('RPO_API_KEY');
    if (!apiUrl || !apiKey) {
      throw new Error('RPO_API_URL / RPO_API_KEY が未設定です');
    }

    // /api/sync/applicants → /api/sync/company-sheets
    var url = apiUrl.replace(/\/api\/sync\/applicants\b/, '/api/sync/company-sheets');

    var response = UrlFetchApp.fetch(url, {
      method: 'get',
      headers: { 'x-rpo-api-key': apiKey },
      muteHttpExceptions: true,
    });

    var status = response.getResponseCode();
    if (status < 200 || status >= 300) {
      throw new Error('company-sheets API error (' + status + '): ' + response.getContentText());
    }

    var body = JSON.parse(response.getContentText());
    return body.data && body.data.sheets ? body.data.sheets : [];
  }

  /* --- グループ化 --- */

  function groupBySpreadsheetAndGid_(sheets) {
    var map = {};
    var order = [];

    for (var i = 0; i < sheets.length; i++) {
      var s = sheets[i];
      var key = s.spreadsheetId + '::' + (s.gid || 0);
      if (!map[key]) {
        map[key] = {
          spreadsheetId: s.spreadsheetId,
          gid: s.gid || 0,
          companies: [],
        };
        order.push(key);
      }
      map[key].companies.push(s.companyName || s.companyId);
    }

    return order.map(function (k) { return map[k]; });
  }

  /* --- シート複製 --- */

  function duplicateSheet_(spreadsheetId, sourceGid) {
    var ss = SpreadsheetApp.openById(spreadsheetId);
    var sourceSheet = getSheetByGid_(ss, sourceGid);

    if (!sourceSheet) {
      throw new Error('GID ' + sourceGid + ' のシートが見つかりません');
    }

    var baseName = sourceSheet.getName() + DUP_CONFIG.newSheetSuffix;
    var newName = makeUniqueName_(ss, baseName);

    var newSheet = sourceSheet.copyTo(ss);
    newSheet.setName(newName);

    var newGid = newSheet.getSheetId();

    Logger.log('[OK] ' + spreadsheetId + ': GID ' + sourceGid + ' → ' + newGid + ' (' + newName + ')');

    return { newGid: newGid, newSheetName: newName };
  }

  function getSheetByGid_(ss, gid) {
    var sheets = ss.getSheets();
    for (var i = 0; i < sheets.length; i++) {
      if (sheets[i].getSheetId() === gid) return sheets[i];
    }
    return null;
  }

  function makeUniqueName_(ss, baseName) {
    var existing = {};
    var sheets = ss.getSheets();
    for (var i = 0; i < sheets.length; i++) {
      existing[sheets[i].getName()] = true;
    }

    if (!existing[baseName]) return baseName;

    for (var n = 2; n <= 100; n++) {
      var candidate = baseName + '_' + n;
      if (!existing[candidate]) return candidate;
    }

    return baseName + '_' + Date.now();
  }

  /* --- ユーティリティ --- */

  function getProp_(key) {
    return (PropertiesService.getScriptProperties().getProperty(key) || '').trim();
  }

  function runOne(spreadsheetId, sourceGid) {
    Logger.log('=== 単一シート複製 開始 ===');
    Logger.log('spreadsheetId: ' + spreadsheetId);
    Logger.log('sourceGid: ' + sourceGid);

    try {
      var result = duplicateSheet_(spreadsheetId, sourceGid);
      Logger.log('');
      Logger.log('========================================');
      Logger.log('  複製成功');
      Logger.log('========================================');
      Logger.log('spreadsheetId: ' + spreadsheetId);
      Logger.log('旧GID: ' + sourceGid);
      Logger.log('新GID: ' + result.newGid);
      Logger.log('新シート名: ' + result.newSheetName);
      Logger.log('');
      Logger.log('管理画面でGIDを ' + result.newGid + ' に更新してください');
      return result;
    } catch (e) {
      Logger.log('[ERROR] ' + (e && e.message ? e.message : String(e)));
      throw e;
    }
  }

  return { run: run, runOne: runOne };
})();
