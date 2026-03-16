import { NextResponse } from "next/server"

import { auth } from "@/auth"
import { db, schema } from "@/db"
import { isAdminUser } from "@/lib/userAccess"
import { getAccessToken } from "@/lib/google-auth"
import { eq } from "drizzle-orm"

export const runtime = "nodejs"

const TARGET_HEADERS = [
    "応募日",        // A
    "会社名",        // B
    "案件名",        // C
    "氏名",          // D
    "mail",          // E
    "応募職種名",    // F
    "勤務地",        // G
    "電話番号",      // H
    "年齢",          // I
    "生年月日",      // J
    "性別",          // K
    "担当者名",      // L
    "有効応募",      // M
    "対応状況",      // N
    "備考",          // O
    "次回アクション日", // P
    "連電日",        // Q
    "面接予定日",    // R
    "実施可否",      // S
    "二次/最終面接予定日", // T
    "二次/最終実施可否",   // U
    "内定可否",      // V
    "入社日",        // W
    "_applicant_id", // X (hidden key)
]

const TOTAL_COLS = TARGET_HEADERS.length // 24 (A-X)

const CHECKBOX_COLS = [13, 19, 21, 22] // M, S, U, V (1-based)
const DATE_COLS = [1, 10, 16, 17, 18, 20, 23] // A, J, P, Q, R, T, W (1-based)

type SheetResult = {
    spreadsheetId: string
    companyName: string
    gid: number
    status: "success" | "error" | "skipped"
    message: string
    rowCount?: number
}

export async function POST() {
    try {
        const session = await auth()
        if (!isAdminUser(session?.user?.email)) {
            return NextResponse.json({ success: false, error: "Unauthorized" }, { status: 401 })
        }

        const token = await getAccessToken()

        // Get all enabled company sheets from DB
        const rows = await db
            .select({
                id: schema.companySheets.id,
                companyName: schema.companies.name,
                spreadsheetId: schema.companySheets.spreadsheetId,
                gid: schema.companySheets.gid,
            })
            .from(schema.companySheets)
            .leftJoin(schema.companies, eq(schema.companySheets.companyId, schema.companies.id))
            .where(eq(schema.companySheets.enabled, true))
            .all()

        // Group by spreadsheetId to avoid processing the same spreadsheet twice
        const seen = new Set<string>()
        const uniqueSheets: typeof rows = []
        for (const row of rows) {
            const key = `${row.spreadsheetId}:${row.gid}`
            if (!seen.has(key)) {
                seen.add(key)
                uniqueSheets.push(row)
            }
        }

        const results: SheetResult[] = []

        for (const sheet of uniqueSheets) {
            const gid = sheet.gid ?? 0
            try {
                const result = await migrateOneSheet(token, sheet.spreadsheetId, gid, sheet.companyName || "Unknown")
                results.push(result)
            } catch (error) {
                results.push({
                    spreadsheetId: sheet.spreadsheetId,
                    companyName: sheet.companyName || "Unknown",
                    gid,
                    status: "error",
                    message: error instanceof Error ? error.message : String(error),
                })
            }
        }

        const summary = {
            total: results.length,
            success: results.filter(r => r.status === "success").length,
            skipped: results.filter(r => r.status === "skipped").length,
            failed: results.filter(r => r.status === "error").length,
        }

        return NextResponse.json({ success: true, summary, results })
    } catch (error) {
        console.error("migrate-sheets failed", error)
        return NextResponse.json(
            { success: false, error: error instanceof Error ? error.message : "Internal Server Error" },
            { status: 500 }
        )
    }
}

async function migrateOneSheet(
    token: string,
    spreadsheetId: string,
    gid: number,
    companyName: string,
): Promise<SheetResult> {
    const base = { spreadsheetId, companyName, gid }

    // 1. Get spreadsheet info to find the target sheet
    const ssResp = await fetch(
        `https://sheets.googleapis.com/v4/spreadsheets/${spreadsheetId}?fields=sheets(properties,data.rowData.values.formattedValue)&includeGridData=true`,
        { headers: { Authorization: `Bearer ${token}` } }
    )
    if (!ssResp.ok) {
        const text = await ssResp.text()
        return { ...base, status: "error", message: `Failed to read spreadsheet: ${ssResp.status} ${text.slice(0, 200)}` }
    }

    const ssData = await ssResp.json() as {
        sheets: Array<{
            properties: { sheetId: number; title: string; gridProperties: { rowCount: number; columnCount: number } }
            data: Array<{ rowData?: Array<{ values?: Array<{ formattedValue?: string }> }> }>
        }>
    }

    const targetSheet = ssData.sheets.find(s => s.properties.sheetId === gid)
    if (!targetSheet) {
        return { ...base, status: "error", message: `Tab with GID=${gid} not found` }
    }

    const sheetTitle = targetSheet.properties.title
    const rowData = targetSheet.data?.[0]?.rowData ?? []

    // 2. Read existing headers (row 1)
    const existingHeaders: string[] = []
    const headerRow = rowData[0]?.values ?? []
    for (let i = 0; i < headerRow.length; i++) {
        existingHeaders.push(headerRow[i]?.formattedValue ?? "")
    }

    // Check if already migrated
    const headersMatch = TARGET_HEADERS.every((h, i) => existingHeaders[i] === h)
    if (headersMatch) {
        return { ...base, status: "skipped", message: "Already has target structure", rowCount: Math.max(0, rowData.length - 1) }
    }

    // 3. Read existing data rows and build column mapping
    const oldColMap = new Map<string, number>() // header -> old column index
    for (let i = 0; i < existingHeaders.length; i++) {
        if (existingHeaders[i]) {
            oldColMap.set(existingHeaders[i], i)
        }
    }

    // Build rearranged data
    const dataRows = rowData.slice(1) // skip header
    const newRows: string[][] = []

    for (const row of dataRows) {
        const values = row?.values ?? []
        const newRow: string[] = new Array(TOTAL_COLS).fill("")

        for (let newCol = 0; newCol < TARGET_HEADERS.length; newCol++) {
            const header = TARGET_HEADERS[newCol]
            const oldCol = oldColMap.get(header)
            if (oldCol !== undefined && oldCol < values.length) {
                newRow[newCol] = values[oldCol]?.formattedValue ?? ""
            }
        }
        newRows.push(newRow)
    }

    // 4. Ensure enough columns
    const currentCols = targetSheet.properties.gridProperties.columnCount
    const requests: unknown[] = []

    if (currentCols < TOTAL_COLS) {
        requests.push({
            appendDimension: {
                sheetId: gid,
                dimension: "COLUMNS",
                length: TOTAL_COLS - currentCols,
            },
        })
    }

    // 5. Clear all content
    requests.push({
        updateCells: {
            range: { sheetId: gid },
            fields: "userEnteredValue,dataValidation",
        },
    })

    // 6. Write new header row
    requests.push({
        updateCells: {
            range: { sheetId: gid, startRowIndex: 0, endRowIndex: 1, startColumnIndex: 0, endColumnIndex: TOTAL_COLS },
            rows: [{
                values: TARGET_HEADERS.map(h => ({
                    userEnteredValue: { stringValue: h },
                })),
            }],
            fields: "userEnteredValue",
        },
    })

    // 7. Write data rows
    if (newRows.length > 0) {
        const batchSize = 500
        for (let i = 0; i < newRows.length; i += batchSize) {
            const batch = newRows.slice(i, i + batchSize)
            requests.push({
                updateCells: {
                    range: {
                        sheetId: gid,
                        startRowIndex: 1 + i,
                        endRowIndex: 1 + i + batch.length,
                        startColumnIndex: 0,
                        endColumnIndex: TOTAL_COLS,
                    },
                    rows: batch.map(row => ({
                        values: row.map((cell, colIdx) => {
                            const col1 = colIdx + 1
                            if (!cell) return { userEnteredValue: { stringValue: "" } }

                            if (CHECKBOX_COLS.includes(col1)) {
                                const boolVal = cell === "TRUE" || cell === "true" || cell === "1"
                                return { userEnteredValue: { boolValue: boolVal } }
                            }

                            if (DATE_COLS.includes(col1) && cell) {
                                const match = cell.match(/^(\d{4})-(\d{2})-(\d{2})/)
                                if (match) {
                                    const serial = dateToSerial(Number(match[1]), Number(match[2]), Number(match[3]))
                                    return {
                                        userEnteredValue: { numberValue: serial },
                                        userEnteredFormat: { numberFormat: { type: "DATE", pattern: "yyyy-mm-dd" } },
                                    }
                                }
                            }

                            const num = Number(cell)
                            if (col1 === 9 && Number.isFinite(num)) { // 年齢
                                return { userEnteredValue: { numberValue: num } }
                            }

                            return { userEnteredValue: { stringValue: cell } }
                        }),
                    })),
                    fields: "userEnteredValue,userEnteredFormat",
                },
            })
        }

        // 8. Set checkbox validation
        for (const col1 of CHECKBOX_COLS) {
            requests.push({
                setDataValidation: {
                    range: {
                        sheetId: gid,
                        startRowIndex: 1,
                        endRowIndex: 1 + newRows.length,
                        startColumnIndex: col1 - 1,
                        endColumnIndex: col1,
                    },
                    rule: {
                        condition: { type: "BOOLEAN" },
                        showCustomUi: true,
                    },
                },
            })
        }
    }

    // 9. Hide _applicant_id column (X)
    requests.push({
        updateDimensionProperties: {
            range: {
                sheetId: gid,
                dimension: "COLUMNS",
                startIndex: TOTAL_COLS - 1,
                endIndex: TOTAL_COLS,
            },
            properties: { hiddenByUser: true },
            fields: "hiddenByUser",
        },
    })

    // Execute batchUpdate
    const batchResp = await fetch(
        `https://sheets.googleapis.com/v4/spreadsheets/${spreadsheetId}:batchUpdate`,
        {
            method: "POST",
            headers: {
                Authorization: `Bearer ${token}`,
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ requests }),
        }
    )

    if (!batchResp.ok) {
        const text = await batchResp.text()
        return { ...base, status: "error", message: `batchUpdate failed: ${batchResp.status} ${text.slice(0, 300)}` }
    }

    return { ...base, status: "success", message: `Migrated ${sheetTitle}: ${newRows.length} rows`, rowCount: newRows.length }
}

function dateToSerial(year: number, month: number, day: number): number {
    // Google Sheets serial date (days since 1899-12-30)
    const d = new Date(year, month - 1, day)
    const epoch = new Date(1899, 11, 30)
    return Math.round((d.getTime() - epoch.getTime()) / (24 * 60 * 60 * 1000))
}
