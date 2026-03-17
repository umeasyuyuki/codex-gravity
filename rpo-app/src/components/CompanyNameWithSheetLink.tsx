"use client"

import { ExternalLink } from "lucide-react"

type SheetEntry = {
    spreadsheetId: string
    gid: number
    sheetName: string | null
}

type Props = {
    companyName: string
    sheetEntry?: SheetEntry | null
    className?: string
}

function buildUrl(entry: SheetEntry): string {
    return `https://docs.google.com/spreadsheets/d/${entry.spreadsheetId}/edit#gid=${entry.gid}`
}

export default function CompanyNameWithSheetLink({ companyName, sheetEntry, className }: Props) {
    return (
        <span className={`inline-flex items-center gap-1 ${className ?? ""}`}>
            <span className="truncate">{companyName}</span>
            {sheetEntry && (
                <a
                    href={buildUrl(sheetEntry)}
                    target="_blank"
                    rel="noopener noreferrer"
                    title={`${companyName} のスプレッドシートを開く${sheetEntry.sheetName ? ` (${sheetEntry.sheetName})` : ""}`}
                    onClick={(e) => e.stopPropagation()}
                    className="inline-flex items-center justify-center shrink-0 w-5 h-5 rounded hover:bg-primary/10 text-muted-foreground hover:text-primary transition-colors duration-150"
                >
                    <ExternalLink className="w-3.5 h-3.5" />
                </a>
            )}
        </span>
    )
}
