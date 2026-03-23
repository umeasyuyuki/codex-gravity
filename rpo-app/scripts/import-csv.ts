/**
 * CSV → D1 インポートスクリプト
 *
 * 使い方:
 *   npx tsx scripts/import-csv.ts --dry-run   # 検証のみ（DB書き込みなし）
 *   npx tsx scripts/import-csv.ts              # 本番実行
 */

import { parse } from "csv-parse/sync";
import * as fs from "fs";
import * as path from "path";
import * as os from "os";
import { execSync } from "child_process";
import { randomUUID } from "crypto";
import { normalizeCompanyName, normalizeCompanyNameForMatch } from "../src/lib/company-name";

// ─── Config ───────────────────────────────────────────────
const CSV_PATH = path.resolve(__dirname, "../../../応募者データ (52).csv");
const RPA_APP_DIR = path.resolve(__dirname, "..");
const DB_NAME = "rpo-db";
const BATCH_SIZE = 50;
const DRY_RUN = process.argv.includes("--dry-run");

// ─── Types ────────────────────────────────────────────────
interface CsvRow {
  応募日: string;
  応募先会社名: string;
  名前: string;
  電話番号: string;
  応募職種: string;
  応募勤務拠点: string;
  年齢: string;
  性別: string;
  担当者名: string;
  有効応募: string;
  対応状況: string;
  備考: string;
  通電日: string;
  次回アクション日: string;
  面接実施予定日: string;
  実施可否: string;
  "二次/最終面接予定日": string;
  "実施可否（二次/最終）": string;
  内定可否: string;
  入社日: string;
  応募タイトル: string;
  面接予定日: string;
  Email: string;
  TEL: string;
  生年月日: string;
  住所: string;
  振り仮名: string;
  管理ID: string;
}

// ─── SQL helpers ──────────────────────────────────────────
function sqlEsc(value: string | null | undefined): string {
  if (value == null || value === "") return "NULL";
  return `'${value.replace(/'/g, "''")}'`;
}

function sqlInt(value: number | null | undefined): string {
  if (value == null) return "NULL";
  return String(value);
}

function sqlBool(value: boolean): string {
  return value ? "1" : "0";
}

function sqlNullBool(value: boolean | null): string {
  if (value === null) return "NULL";
  return value ? "1" : "0";
}

// ─── Date parsing ─────────────────────────────────────────
function parseDate(value: string | undefined): Date | null {
  if (!value?.trim()) return null;
  const trimmed = value.trim();

  // "2026/03/11 08:42:48" → replace / with -
  const normalized = trimmed.replace(/\//g, "-");
  const d = new Date(normalized);
  return isNaN(d.getTime()) ? null : d;
}

function toUnix(date: Date | null): number | null {
  if (!date) return null;
  return Math.floor(date.getTime() / 1000);
}

function parseDateToUnix(value: string | undefined): number | null {
  return toUnix(parseDate(value));
}

// ─── Field parsers ────────────────────────────────────────
function parseAge(value: string | undefined): number | null {
  if (!value?.trim()) return null;
  const match = value.match(/(\d+)/);
  return match ? parseInt(match[1], 10) : null;
}

function parseValidity(value: string | undefined): boolean | null {
  if (!value?.trim()) return null;
  if (value.includes("◯") || value.includes("○")) return true;
  if (value.includes("✕") || value.includes("×")) return false;
  return null;
}

// ─── 対応状況 → ワークフローフラグ変換 ────────────────────
function mapStatusToFlags(status: string) {
  const s = status.trim();

  // デフォルト：全フラグ false
  const flags = {
    docDeclined: false,
    docRejectedMK: false,
    docRejectedClient: false,
    schedulingInterview: false,
    interviewDeclinedBefore: false,
    primaryScheduled: false,
    primaryConducted: false,
    primaryDeclinedAfter: false,
    primaryRejected: false,
    primaryNoShow: false,
    secScheduled: false,
    secConducted: false,
    secDeclinedBefore: false,
    secDeclinedAfter: false,
    secRejected: false,
    secNoShow: false,
    offered: false,
    offerDeclined: false,
    joined: false,
  };

  switch (s) {
    // ── 書類段階 ──
    case "書類不採用（MK対応）":
      flags.docRejectedMK = true;
      break;
    case "書類不採用（クライアント判断）":
    case "書類不採用":
      flags.docRejectedClient = true;
      break;
    case "書類選考中辞退":
      flags.docDeclined = true;
      break;

    // ── 面接調整段階 ──
    case "企業面接日程調整中":
    case "面接日程再調整中":
    case "電話アポ日程調整中":
      flags.schedulingInterview = true;
      break;

    // ── 面接確定 ──
    case "面接日程確定済み":
    case "電話アポ日程確定済み":
      flags.primaryScheduled = true;
      break;

    // ── 面接前辞退 ──
    case "面接前辞退":
      flags.interviewDeclinedBefore = true;
      break;

    // ── 面接結果 ──
    case "面接不採用":
      flags.primaryConducted = true;
      flags.primaryRejected = true;
      break;
    case "面接後辞退":
      flags.primaryConducted = true;
      flags.primaryDeclinedAfter = true;
      break;
    case "面接飛び":
      flags.primaryNoShow = true;
      break;

    // ── 二次/最終面接 ──
    case "二次/最終面接日程調整中":
      flags.primaryConducted = true;
      flags.schedulingInterview = true;
      break;
    case "二次/最終面接日程確定済み":
      flags.primaryConducted = true;
      flags.secScheduled = true;
      break;
    case "二次/最終面接前辞退":
      flags.primaryConducted = true;
      flags.secDeclinedBefore = true;
      break;
    case "二次/最終面接不採用":
      flags.primaryConducted = true;
      flags.secConducted = true;
      flags.secRejected = true;
      break;

    // ── 内定・入社 ──
    case "内定":
      flags.primaryConducted = true;
      flags.offered = true;
      break;
    case "内定後辞退":
      flags.primaryConducted = true;
      flags.offered = true;
      flags.offerDeclined = true;
      break;
    case "入社":
      flags.primaryConducted = true;
      flags.offered = true;
      flags.joined = true;
      break;
    case "入社前辞退":
      flags.primaryConducted = true;
      flags.offered = true;
      flags.offerDeclined = true;
      break;

    // ── それ以外（追電中、公式LINE誘導中、MK提案済み等）はフラグ変更なし ──
    default:
      break;
  }

  return flags;
}

// ─── D1 実行 ──────────────────────────────────────────────
/** INSERT/UPDATE バッチ実行（--file 使用） */
function executeD1(sql: string): void {
  const tmpFile = path.join(
    os.tmpdir(),
    `d1-import-${Date.now()}-${Math.random().toString(36).slice(2)}.sql`
  );
  fs.writeFileSync(tmpFile, sql, "utf-8");
  try {
    let stdout: string;
    try {
      stdout = execSync(
        `npx wrangler d1 execute ${DB_NAME} --remote --json --file="${tmpFile}" 2>/dev/null`,
        { cwd: RPA_APP_DIR, maxBuffer: 50 * 1024 * 1024, encoding: "utf-8" }
      );
    } catch (execError: unknown) {
      const e = execError as { stdout?: string };
      stdout = e.stdout || "";
      if (!stdout) throw execError;
    }
    // エラーチェック
    const objStart = stdout.indexOf("{");
    if (objStart !== -1) {
      // { "error": ... } 形式のエラーレスポンスを検出
      const firstBrace = stdout.slice(objStart);
      try {
        const parsed = JSON.parse(firstBrace);
        if (parsed.error) {
          throw new Error(
            `D1 error: ${parsed.error.text || JSON.stringify(parsed.error)}`
          );
        }
      } catch (parseErr) {
        // JSON配列レスポンスの場合はここでエラーになるが無視してよい
        if (parseErr instanceof SyntaxError) {
          /* ok */
        } else {
          throw parseErr;
        }
      }
    }
  } finally {
    fs.unlinkSync(tmpFile);
  }
}

/** SELECT クエリ実行（--command 使用、実データを返す） */
function queryD1<T = Record<string, unknown>>(sql: string): T[] {
  const escaped = sql.replace(/"/g, '\\"');
  let stdout: string;
  try {
    stdout = execSync(
      `npx wrangler d1 execute ${DB_NAME} --remote --json --command "${escaped}" 2>/dev/null`,
      { cwd: RPA_APP_DIR, maxBuffer: 50 * 1024 * 1024, encoding: "utf-8" }
    );
  } catch (execError: unknown) {
    const e = execError as { stdout?: string };
    stdout = e.stdout || "";
    if (!stdout) throw execError;
  }
  const jsonStart = stdout.indexOf("[");
  if (jsonStart === -1) {
    throw new Error(`queryD1: no JSON array in response: ${stdout.slice(0, 200)}`);
  }
  const raw = JSON.parse(stdout.slice(jsonStart)) as Array<{ results?: T[] }>;
  return raw[0]?.results ?? [];
}

// ─── Main ─────────────────────────────────────────────────
async function main() {
  console.log(DRY_RUN ? "=== DRY RUN ===" : "=== IMPORT ===");

  // ── 1. CSV パース ──
  console.log(`\n[1/6] CSV パース: ${CSV_PATH}`);
  const csvContent = fs.readFileSync(CSV_PATH, "utf-8").replace(/^\uFEFF/, ""); // BOM除去
  const rows: CsvRow[] = parse(csvContent, {
    columns: true,
    skip_empty_lines: true,
    relax_column_count: true,
    relax_quotes: true,
  });
  console.log(`  → ${rows.length} 行`);

  // ── 2. 既存データ取得 ──
  console.log("\n[2/6] 既存データ取得...");
  const existingCompanies = new Map<string, string>();
  for (const c of queryD1<{ id: string; name: string }>(
    "SELECT id, name FROM company;"
  )) {
    existingCompanies.set(c.name, c.id);
  }
  console.log(`  → 企業: ${existingCompanies.size} 件`);

  const existingByEmail = new Map<string, string>();
  const existingByNCD = new Map<string, string>(); // name|companyId|appliedAt
  for (const a of queryD1<{
    id: string;
    email: string | null;
    name: string;
    company_id: string;
    applied_at: number;
  }>("SELECT id, email, name, company_id, applied_at FROM applicant;")) {
    if (a.email) {
      existingByEmail.set(a.email.toLowerCase(), a.id);
    }
    existingByNCD.set(`${a.name}|${a.company_id}|${a.applied_at}`, a.id);
  }
  console.log(`  → 応募者: ${existingByEmail.size} 件 (email), ${existingByNCD.size} 件 (name+co+date)`);

  // ── 3. 企業 upsert（正規化マッチング対応）──
  console.log("\n[3/6] 企業 upsert...");
  const companySqls: string[] = [];
  const aliasSqls: string[] = [];
  const companyNames = new Set(
    rows.map((r) => r.応募先会社名?.trim()).filter(Boolean)
  );

  // 正規化名 → 企業ID のマップを作成
  const existingByNormalized = new Map<string, { id: string; name: string }>();
  for (const [name, id] of existingCompanies) {
    existingByNormalized.set(normalizeCompanyNameForMatch(name), { id, name });
  }

  let fuzzyMatched = 0;
  for (const name of companyNames) {
    if (existingCompanies.has(name)) continue;

    // 正規化マッチング
    const normalized = normalizeCompanyNameForMatch(name);
    const match = normalized.length >= 2 ? existingByNormalized.get(normalized) : undefined;

    if (match) {
      // 既存企業にマッピング + エイリアス登録
      const displayName = normalizeCompanyName(name);
      existingCompanies.set(name, match.id);
      fuzzyMatched++;
      console.log(`  → 正規化マッチ: "${name}" → "${match.name}"`);
      aliasSqls.push(
        `INSERT OR IGNORE INTO company_alias (id, company_id, alias, created_at) VALUES (${sqlEsc(randomUUID())}, ${sqlEsc(match.id)}, ${sqlEsc(displayName)}, strftime('%s','now'));`
      );
    } else {
      const id = randomUUID();
      existingCompanies.set(name, id);
      existingByNormalized.set(normalized, { id, name });
      companySqls.push(
        `INSERT OR IGNORE INTO company (id, name, created_at, updated_at) VALUES (${sqlEsc(id)}, ${sqlEsc(name)}, strftime('%s','now'), strftime('%s','now'));`
      );
    }
  }
  console.log(`  → 正規化マッチ: ${fuzzyMatched} 件`);
  console.log(`  → 新規企業: ${companySqls.length} 件`);
  console.log(`  → エイリアス登録: ${aliasSqls.length} 件`);

  if (!DRY_RUN) {
    if (companySqls.length > 0) {
      for (let i = 0; i < companySqls.length; i += BATCH_SIZE) {
        executeD1(companySqls.slice(i, i + BATCH_SIZE).join("\n"));
      }
      console.log("  → 企業挿入完了");
    }

    if (aliasSqls.length > 0) {
      for (let i = 0; i < aliasSqls.length; i += BATCH_SIZE) {
        executeD1(aliasSqls.slice(i, i + BATCH_SIZE).join("\n"));
      }
      console.log("  → エイリアス登録完了");
    }

    // 再取得して ID マップを確実にする
    existingCompanies.clear();
    for (const c of queryD1<{ id: string; name: string }>(
      "SELECT id, name FROM company;"
    )) {
      existingCompanies.set(c.name, c.id);
    }
    // エイリアスも逆引きマップに追加
    for (const a of queryD1<{ alias: string; company_id: string }>(
      "SELECT alias, company_id FROM company_alias;"
    )) {
      if (!existingCompanies.has(a.alias)) {
        existingCompanies.set(a.alias, a.company_id);
      }
    }
    console.log(`  → 企業マスタ再取得: ${existingCompanies.size} 件`);
  }

  // ── 4. 応募者データ変換 ──
  console.log("\n[4/6] 応募者データ変換...");
  const insertSqls: string[] = [];
  const updateSqls: string[] = [];
  const errors: { line: number; error: string; name: string }[] = [];

  const COLUMNS = [
    "id",
    "company_id",
    "name",
    "furigana",
    "email",
    "phone",
    "gender",
    "assignee_name",
    "response_status",
    "age",
    "birth_date",
    "address",
    "case_name",
    "applied_job",
    "applied_location",
    "notes",
    "connected_at",
    "next_action_date",
    "applied_at",
    "is_valid_applicant",
    "doc_declined",
    "doc_rejected_mk",
    "doc_rejected_client",
    "scheduling_interview",
    "interview_declined_before",
    "primary_scheduled",
    "primary_scheduled_date",
    "primary_conducted",
    "primary_declined_after",
    "primary_rejected",
    "primary_no_show",
    "sec_scheduled",
    "sec_scheduled_date",
    "sec_conducted",
    "sec_declined_before",
    "sec_declined_after",
    "sec_rejected",
    "sec_no_show",
    "offered",
    "offer_declined",
    "joined",
    "joined_date",
    "created_at",
    "updated_at",
  ].join(", ");

  for (let i = 0; i < rows.length; i++) {
    const row = rows[i];
    const lineNum = i + 2;

    try {
      const name = row.名前?.trim();
      const companyName = row.応募先会社名?.trim();
      const appliedAt = parseDateToUnix(row.応募日);

      if (!name) {
        errors.push({ line: lineNum, error: "名前が空", name: "" });
        continue;
      }
      if (!companyName) {
        errors.push({ line: lineNum, error: "会社名が空", name });
        continue;
      }
      if (appliedAt == null) {
        errors.push({ line: lineNum, error: "応募日が不正", name });
        continue;
      }

      const companyId = existingCompanies.get(companyName)
        ?? existingCompanies.get(normalizeCompanyName(companyName));
      if (!companyId) {
        errors.push({ line: lineNum, error: "企業IDが見つからない", name });
        continue;
      }

      const email =
        row.Email?.trim().toLowerCase() || null;
      const phone =
        row.電話番号?.trim() || row.TEL?.trim() || null;
      const statusFlags = mapStatusToFlags(row.対応状況 || "");
      const connectedAt = parseDateToUnix(row.通電日);
      const nextActionDate = parseDateToUnix(row.次回アクション日);
      const primaryScheduledDate = parseDateToUnix(
        row.面接実施予定日 || row.面接予定日
      );
      const secScheduledDate = parseDateToUnix(row["二次/最終面接予定日"]);
      const joinedDate = parseDateToUnix(row.入社日);
      const birthDate = parseDateToUnix(row.生年月日);
      const validity = parseValidity(row.有効応募);

      // 面接日程カラムからもフラグを補完
      if (primaryScheduledDate) statusFlags.primaryScheduled = true;
      if (row.実施可否?.trim()) statusFlags.primaryConducted = true;
      if (secScheduledDate) statusFlags.secScheduled = true;
      if (row["実施可否（二次/最終）"]?.trim()) statusFlags.secConducted = true;
      if (row.内定可否?.trim()) statusFlags.offered = true;
      if (joinedDate) statusFlags.joined = true;

      // 既存チェック
      let existingId: string | undefined;
      if (email) {
        existingId = existingByEmail.get(email);
      }
      if (!existingId) {
        existingId = existingByNCD.get(`${name}|${companyId}|${appliedAt}`);
      }

      if (existingId) {
        // ── UPDATE ──
        const sets = [
          `company_id = ${sqlEsc(companyId)}`,
          `name = ${sqlEsc(name)}`,
          `furigana = ${sqlEsc(row.振り仮名?.trim() || null)}`,
          `email = ${sqlEsc(email)}`,
          `phone = ${sqlEsc(phone)}`,
          `gender = ${sqlEsc(row.性別?.trim() || null)}`,
          `assignee_name = ${sqlEsc(row.担当者名?.trim() || null)}`,
          `response_status = ${sqlEsc(row.対応状況?.trim() || null)}`,
          `age = ${sqlInt(parseAge(row.年齢))}`,
          `birth_date = ${sqlInt(birthDate)}`,
          `address = ${sqlEsc(row.住所?.trim() || null)}`,
          `case_name = ${sqlEsc(row.応募タイトル?.trim() || null)}`,
          `applied_job = ${sqlEsc(row.応募職種?.trim() || null)}`,
          `applied_location = ${sqlEsc(row.応募勤務拠点?.trim() || null)}`,
          `notes = ${sqlEsc(row.備考?.trim() || null)}`,
          `connected_at = ${sqlInt(connectedAt)}`,
          `next_action_date = ${sqlInt(nextActionDate)}`,
          `applied_at = ${sqlInt(appliedAt)}`,
          `is_valid_applicant = ${sqlNullBool(validity)}`,
          `doc_declined = ${sqlBool(statusFlags.docDeclined)}`,
          `doc_rejected_mk = ${sqlBool(statusFlags.docRejectedMK)}`,
          `doc_rejected_client = ${sqlBool(statusFlags.docRejectedClient)}`,
          `scheduling_interview = ${sqlBool(statusFlags.schedulingInterview)}`,
          `interview_declined_before = ${sqlBool(statusFlags.interviewDeclinedBefore)}`,
          `primary_scheduled = ${sqlBool(statusFlags.primaryScheduled)}`,
          `primary_scheduled_date = ${sqlInt(primaryScheduledDate)}`,
          `primary_conducted = ${sqlBool(statusFlags.primaryConducted)}`,
          `primary_declined_after = ${sqlBool(statusFlags.primaryDeclinedAfter)}`,
          `primary_rejected = ${sqlBool(statusFlags.primaryRejected)}`,
          `primary_no_show = ${sqlBool(statusFlags.primaryNoShow)}`,
          `sec_scheduled = ${sqlBool(statusFlags.secScheduled)}`,
          `sec_scheduled_date = ${sqlInt(secScheduledDate)}`,
          `sec_conducted = ${sqlBool(statusFlags.secConducted)}`,
          `sec_declined_before = ${sqlBool(statusFlags.secDeclinedBefore)}`,
          `sec_declined_after = ${sqlBool(statusFlags.secDeclinedAfter)}`,
          `sec_rejected = ${sqlBool(statusFlags.secRejected)}`,
          `sec_no_show = ${sqlBool(statusFlags.secNoShow)}`,
          `offered = ${sqlBool(statusFlags.offered)}`,
          `offer_declined = ${sqlBool(statusFlags.offerDeclined)}`,
          `joined = ${sqlBool(statusFlags.joined)}`,
          `joined_date = ${sqlInt(joinedDate)}`,
          `updated_at = strftime('%s','now')`,
        ];
        updateSqls.push(
          `UPDATE applicant SET ${sets.join(", ")} WHERE id = ${sqlEsc(existingId)};`
        );
      } else {
        // ── INSERT ──
        const id = randomUUID();
        const vals = [
          sqlEsc(id),
          sqlEsc(companyId),
          sqlEsc(name),
          sqlEsc(row.振り仮名?.trim() || null),
          sqlEsc(email),
          sqlEsc(phone),
          sqlEsc(row.性別?.trim() || null),
          sqlEsc(row.担当者名?.trim() || null),
          sqlEsc(row.対応状況?.trim() || null),
          sqlInt(parseAge(row.年齢)),
          sqlInt(birthDate),
          sqlEsc(row.住所?.trim() || null),
          sqlEsc(row.応募タイトル?.trim() || null),
          sqlEsc(row.応募職種?.trim() || null),
          sqlEsc(row.応募勤務拠点?.trim() || null),
          sqlEsc(row.備考?.trim() || null),
          sqlInt(connectedAt),
          sqlInt(nextActionDate),
          sqlInt(appliedAt),
          sqlNullBool(validity),
          sqlBool(statusFlags.docDeclined),
          sqlBool(statusFlags.docRejectedMK),
          sqlBool(statusFlags.docRejectedClient),
          sqlBool(statusFlags.schedulingInterview),
          sqlBool(statusFlags.interviewDeclinedBefore),
          sqlBool(statusFlags.primaryScheduled),
          sqlInt(primaryScheduledDate),
          sqlBool(statusFlags.primaryConducted),
          sqlBool(statusFlags.primaryDeclinedAfter),
          sqlBool(statusFlags.primaryRejected),
          sqlBool(statusFlags.primaryNoShow),
          sqlBool(statusFlags.secScheduled),
          sqlInt(secScheduledDate),
          sqlBool(statusFlags.secConducted),
          sqlBool(statusFlags.secDeclinedBefore),
          sqlBool(statusFlags.secDeclinedAfter),
          sqlBool(statusFlags.secRejected),
          sqlBool(statusFlags.secNoShow),
          sqlBool(statusFlags.offered),
          sqlBool(statusFlags.offerDeclined),
          sqlBool(statusFlags.joined),
          sqlInt(joinedDate),
          "strftime('%s','now')",
          "strftime('%s','now')",
        ];
        insertSqls.push(
          `INSERT INTO applicant (${COLUMNS}) VALUES (${vals.join(", ")});`
        );
      }
    } catch (e) {
      errors.push({
        line: lineNum,
        error: e instanceof Error ? e.message : String(e),
        name: row.名前 || "unknown",
      });
    }
  }

  console.log(`  → INSERT: ${insertSqls.length} 件`);
  console.log(`  → UPDATE: ${updateSqls.length} 件`);
  console.log(`  → エラー: ${errors.length} 件`);

  // ── 5. バッチ実行 ──
  if (!DRY_RUN) {
    if (updateSqls.length > 0) {
      console.log(`\n[5/6] UPDATE 実行 (${updateSqls.length} 件)...`);
      for (let i = 0; i < updateSqls.length; i += BATCH_SIZE) {
        const batch = updateSqls.slice(i, i + BATCH_SIZE);
        try {
          executeD1(batch.join("\n"));
        } catch (e) {
          console.error(
            `  ✗ UPDATE バッチ ${i + 1}-${i + batch.length} 失敗:`,
            e instanceof Error ? e.message : e
          );
        }
        const done = Math.min(i + BATCH_SIZE, updateSqls.length);
        process.stdout.write(`  ${done}/${updateSqls.length} 完了\r`);
      }
      console.log();
    }

    if (insertSqls.length > 0) {
      console.log(`\n[6/6] INSERT 実行 (${insertSqls.length} 件)...`);
      for (let i = 0; i < insertSqls.length; i += BATCH_SIZE) {
        const batch = insertSqls.slice(i, i + BATCH_SIZE);
        try {
          executeD1(batch.join("\n"));
        } catch (e) {
          console.error(
            `  ✗ INSERT バッチ ${i + 1}-${i + batch.length} 失敗:`,
            e instanceof Error ? e.message : e
          );
        }
        const done = Math.min(i + BATCH_SIZE, insertSqls.length);
        process.stdout.write(`  ${done}/${insertSqls.length} 完了\r`);
      }
      console.log();
    }
  } else {
    console.log("\n[5/6] スキップ (dry-run)");
    console.log("[6/6] スキップ (dry-run)");
  }

  // ── サマリー ──
  console.log("\n========== サマリー ==========");
  console.log(`CSV 行数:       ${rows.length}`);
  console.log(`新規企業:       ${companySqls.length}`);
  console.log(`新規応募者:     ${insertSqls.length}`);
  console.log(`更新応募者:     ${updateSqls.length}`);
  console.log(`エラー:         ${errors.length}`);

  if (errors.length > 0) {
    const logPath = path.join(RPA_APP_DIR, "import-errors.log");
    const logContent = errors
      .map((e) => `行${e.line}: [${e.error}] ${e.name}`)
      .join("\n");
    fs.writeFileSync(logPath, logContent, "utf-8");
    console.log(`\nエラー詳細: ${logPath}`);
    // 先頭5件を表示
    for (const e of errors.slice(0, 5)) {
      console.log(`  行${e.line}: ${e.error} (${e.name})`);
    }
    if (errors.length > 5) {
      console.log(`  ... 他 ${errors.length - 5} 件`);
    }
  }

  if (DRY_RUN) {
    console.log("\n★ ドライランのため、DBへの書き込みは行っていません。");
  } else {
    console.log("\n★ インポート完了");
  }
}

main().catch((e) => {
  console.error("致命的エラー:", e);
  process.exit(1);
});
