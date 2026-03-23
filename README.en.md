# RPO 24CS - Recruitment Process Management System

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Language: [日本語](README.md) | English**

---

## Overview

**RPO 24CS** is a web application for recruitment agencies to manage the entire recruitment process outsourcing (RPO) workflow.

It provides unified management of applicant tracking, call log recording & analysis, company-level yield analytics, and Google Sheets integration.

---

## Key Features

| Feature | Description |
|---------|-------------|
| **Applicant Management** | Register, search, and track applicants through the full funnel (40+ status flags from screening to onboarding) |
| **Call Logs** | Record call history, analyze connection rates with day-of-week x time-slot heatmaps |
| **Company Yield Analytics** | Real-time calculation of contact, interview, offer, and joining rates per company |
| **Monthly Reports** | Cross-company monthly recruitment performance aggregation |
| **Google Sheets Integration** | Bidirectional sync with client-facing spreadsheets |
| **External Data Intake** | Automated applicant data import via Indeed / GAS (API) |
| **CSV Export** | Export yield data and monthly totals as CSV |

---

## Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Next.js 16 (App Router) / React 19 / TypeScript 5 |
| Database | Cloudflare D1 (SQLite) / Drizzle ORM |
| Auth | NextAuth.js 5 (Google OAuth / JWT) |
| UI | Tailwind CSS 4 / shadcn/ui (Radix UI) |
| Deployment | Cloudflare Workers (OpenNextJS) |
| Data Sync | Google Apps Script / Google Sheets API |
| Testing | Vitest |

---

## Directory Structure

```
RPO_24CS/
├── rpo-app/                 # Main web application (Next.js)
│   ├── src/
│   │   ├── app/             # Pages & API routes
│   │   ├── components/      # UI components
│   │   ├── db/              # DB schema & client
│   │   ├── lib/             # Business logic & utilities
│   │   └── types/           # Type definitions
│   ├── drizzle/             # DB migrations
│   └── scripts/             # Data import scripts
│
├── gas/                     # Google Apps Script files
├── data/                    # Data files (sample CSVs)
├── docs/                    # Documentation
└── logs/                    # Logs (gitignored)
```

---

## Setup

### Prerequisites

- Node.js 20+
- npm
- Cloudflare account (D1 database)
- Google Cloud Console (OAuth configuration)

### Local Development

```bash
cd rpo-app
npm install
cp .dev.vars.example .dev.vars    # Configure environment variables
cp .env.example .env.local        # Configure auth credentials
npm run dev
```

### Deployment

```bash
cd rpo-app
npx wrangler d1 migrations apply rpo-db
npm run build
npx opennextjs-cloudflare deploy
```

---

## License

MIT License - See [LICENSE](LICENSE) for details.
