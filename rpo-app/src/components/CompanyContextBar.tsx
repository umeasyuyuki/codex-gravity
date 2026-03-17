"use client"

import Link from "next/link"
import { Building2, ExternalLink, Users, BarChart3, Phone } from "lucide-react"

type SheetEntry = {
    spreadsheetId: string
    gid: number
    sheetName: string | null
}

type Props = {
    companyId: string
    companyName: string
    sheetEntry?: SheetEntry | null
    activePage: "applicants" | "companies" | "calls"
}

function buildSheetUrl(entry: SheetEntry): string {
    return `https://docs.google.com/spreadsheets/d/${entry.spreadsheetId}/edit#gid=${entry.gid}`
}

export default function CompanyContextBar({ companyId, companyName, sheetEntry, activePage }: Props) {
    const links = [
        {
            key: "applicants" as const,
            href: `/applicants?companyId=${companyId}`,
            icon: Users,
            label: "応募者",
        },
        {
            key: "companies" as const,
            href: `/companies?companyId=${companyId}`,
            icon: BarChart3,
            label: "歩留まり",
        },
        {
            key: "calls" as const,
            href: `/calls/history?companyId=${companyId}`,
            icon: Phone,
            label: "架電履歴",
        },
    ]

    return (
        <div className="flex items-center gap-3 bg-card px-4 py-2.5 rounded-xl border border-border" style={{ boxShadow: "var(--shadow-soft)" }}>
            <div className="flex items-center gap-2 text-sm font-semibold text-foreground min-w-0">
                <Building2 className="w-4 h-4 text-primary shrink-0" />
                <span className="truncate">{companyName}</span>
            </div>

            <div className="w-px h-5 bg-border shrink-0" />

            <div className="flex items-center gap-1 flex-wrap">
                {links.map((link) => {
                    const isActive = link.key === activePage
                    return (
                        <Link
                            key={link.key}
                            href={link.href}
                            className={`inline-flex items-center gap-1.5 h-7 px-2.5 rounded-md text-[12px] font-medium transition-colors duration-150 ${
                                isActive
                                    ? "bg-primary/10 text-primary"
                                    : "text-muted-foreground hover:text-foreground hover:bg-muted/50"
                            }`}
                        >
                            <link.icon className="w-3.5 h-3.5" />
                            {link.label}
                        </Link>
                    )
                })}

                {sheetEntry && (
                    <a
                        href={buildSheetUrl(sheetEntry)}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1.5 h-7 px-2.5 rounded-md text-[12px] font-medium text-muted-foreground hover:text-foreground hover:bg-muted/50 transition-colors duration-150"
                    >
                        <ExternalLink className="w-3.5 h-3.5" />
                        スプレッドシート
                    </a>
                )}
            </div>

            <div className="ml-auto">
                <Link
                    href={`/${activePage === "calls" ? "calls/history" : activePage}`}
                    className="text-[11px] text-muted-foreground hover:text-foreground transition-colors"
                >
                    フィルタ解除
                </Link>
            </div>
        </div>
    )
}
