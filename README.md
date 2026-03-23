# RPO 24CS - 採用プロセス管理システム

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Language: 日本語 | [English](README.en.md)**

---

## 概要

**RPO 24CS** は、人材紹介会社向けの採用プロセス管理（RPO: Recruitment Process Outsourcing）Webアプリケーションです。

応募者の管理、架電ログの記録・分析、企業別の歩留まり分析、Google スプレッドシートとの連携を一元的に行えます。

---

## 主な機能

| 機能 | 説明 |
|------|------|
| **応募者管理** | 応募者の登録・検索・ステータス追跡（書類選考〜入社まで40+のフラグで管理） |
| **架電ログ** | 架電履歴の記録、接続率のヒートマップ分析（曜日×時間帯） |
| **企業別歩留まり** | 連絡率・面接率・内定率・入社率をリアルタイム算出 |
| **月次集計** | 企業横断の月次採用実績レポート |
| **Google Sheets 連携** | クライアント向けスプレッドシートとの双方向同期 |
| **外部データ取込** | Indeed / GAS 経由での応募者データ自動取込（API） |
| **CSV エクスポート** | 歩留まりデータ・月次集計のCSV出力 |

---

## 技術スタック

| カテゴリ | 技術 |
|----------|------|
| フレームワーク | Next.js 16 (App Router) / React 19 / TypeScript 5 |
| データベース | Cloudflare D1 (SQLite) / Drizzle ORM |
| 認証 | NextAuth.js 5 (Google OAuth / JWT) |
| UI | Tailwind CSS 4 / shadcn/ui (Radix UI) |
| デプロイ | Cloudflare Workers (OpenNextJS) |
| データ連携 | Google Apps Script / Google Sheets API |
| テスト | Vitest |

---

## ディレクトリ構成

```
RPO_24CS/
├── rpo-app/                 # メインWebアプリケーション (Next.js)
│   ├── src/
│   │   ├── app/             # ページ・APIルート
│   │   │   ├── (dashboard)/ # 認証保護されたページ群
│   │   │   │   ├── applicants/   # 応募者管理
│   │   │   │   ├── calls/        # 架電ログ
│   │   │   │   ├── companies/    # 企業・歩留まり
│   │   │   │   └── admin/        # 管理機能
│   │   │   ├── api/         # REST API
│   │   │   │   ├── inbound/      # 外部データ取込
│   │   │   │   ├── sync/         # データ同期
│   │   │   │   └── cron/         # 定期実行
│   │   │   └── login/       # ログインページ
│   │   ├── components/      # UIコンポーネント
│   │   ├── db/              # DBスキーマ・クライアント
│   │   ├── lib/             # ビジネスロジック・ユーティリティ
│   │   └── types/           # 型定義
│   ├── drizzle/             # DBマイグレーション
│   ├── scripts/             # データインポート等
│   └── public/              # 静的ファイル
│
├── gas/                     # Google Apps Script
│   ├── applier_trans.gs          # 応募者データ変換
│   ├── db_to_spreadsheet_sync.gs # DB→スプレッドシート同期
│   ├── db_to_spreadsheet_sync_v2.gs
│   ├── duplicate_sheets.gs       # シート複製
│   ├── migrate_sheet_structure.gs # シート構造マイグレーション
│   └── migrate_tabs.gs           # タブ移行
│
├── data/                    # データファイル
│   └── *.csv                     # 応募者データ（サンプル）
│
├── docs/                    # ドキュメント
│   ├── specification.md          # システム仕様書
│   ├── database-design.md        # DB設計書
│   ├── system-architecture.md    # システムアーキテクチャ
│   ├── gas-inbound-setup.md      # GAS連携セットアップ
│   ├── research/                 # 技術調査
│   ├── reports/                  # 開発レポート
│   └── images/                   # スクリーンショット
│
└── logs/                    # ログ（gitignored）
```

---

## セットアップ

### 前提条件

- Node.js 20+
- npm
- Cloudflare アカウント（D1 データベース）
- Google Cloud Console（OAuth設定）

### ローカル開発

```bash
cd rpo-app
npm install
cp .dev.vars.example .dev.vars    # 環境変数を設定
cp .env.example .env.local        # 認証情報を設定
npm run dev
```

### 環境変数

| 変数名 | 用途 |
|--------|------|
| `AUTH_SECRET` | NextAuth セッション暗号化キー |
| `AUTH_GOOGLE_ID` | Google OAuth クライアントID |
| `AUTH_GOOGLE_SECRET` | Google OAuth クライアントシークレット |
| `RPO_API_KEY` | 外部API認証キー |
| `ALLOWED_LOGIN_LIST` | ログイン許可メールアドレス/ドメイン |

> 実際の値は `.env.local` / `.dev.vars` に設定してください（リポジトリには含まれません）。

### デプロイ

```bash
cd rpo-app
npx wrangler d1 migrations apply rpo-db    # DBマイグレーション
npm run build
npx opennextjs-cloudflare deploy           # Cloudflare Workers にデプロイ
```

---

## API エンドポイント

| メソッド | パス | 概要 |
|----------|------|------|
| `POST` | `/api/inbound/indeed` | Indeed/GAS からの応募者データ取込 |
| `GET` | `/api/sync/companies` | 企業一覧取得 |
| `GET` | `/api/sync/applicants` | 応募者データ取得（フィルタ・ページング対応） |
| `GET` | `/api/sync/company-sheets` | Google Sheets マッピング取得 |
| `GET` | `/api/companies/yields/csv` | 歩留まりCSVエクスポート |
| `GET` | `/api/companies/monthly-yields/csv` | 月次歩留まりCSVエクスポート |

認証: `x-rpo-api-key` ヘッダーによるAPIキー認証

---

## ライセンス

MIT License - 詳細は [LICENSE](LICENSE) を参照してください。
