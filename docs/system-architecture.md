# RPOアプリ システム構成図

## 全体構成（現状ボトルネックを含む）
```mermaid
flowchart LR
    subgraph USER["利用者"]
        BROWSER["採用担当者ブラウザ"]
    end

    subgraph CF["Cloudflare Workers: rpo-app"]
        UI["Next.js App Router<br/>Dashboard UI"]
        MW["Auth.js Middleware<br/>認証・認可"]
        SA["Server Actions<br/>応募者/架電/歩留まり"]
        INB["Inbound API<br/>POST /api/inbound/indeed<br/>(runtime=nodejs)"]
    end

    subgraph EXT["外部サービス"]
        GOOGLE["Google OAuth"]
        GMAIL["Gmail: Indeed応募通知"]
        GAS["Google Apps Script<br/>applier_trans.gs"]
    end

    subgraph DATA["データ基盤"]
        D1[("Cloudflare D1<br/>SQLite")]
    end

    BROWSER --> UI
    UI --> MW
    MW <--> GOOGLE
    UI --> SA
    SA <--> D1

    GMAIL --> GAS
    GAS -->|x-rpo-api-key| INB
    INB --> D1

    subgraph BOTTLENECK["現状ボトルネック"]
        B1["B1: getCallLogs<br/>全件取得 + メモリJoin/Filter"]
        B2["B2: getApplicants/getApplicant<br/>関連データ別取得 + メモリ突合"]
        B3["B3: LIKE '%keyword%'<br/>前方ワイルドカード検索"]
        B4["B4: addCallLog<br/>MAX(call_count)+INSERT(非Tx)"]
        B5["B5: 補助Index不足<br/>company_id/applicant_id/caller_id/called_at/created_at"]
    end

    SA -. read負荷 .-> B1
    SA -. read負荷 .-> B2
    SA -. 検索負荷 .-> B3
    SA -. write競合 .-> B4
    D1 -. scan増大 .-> B5

    classDef bottleneck fill:#ffe9e9,stroke:#c0392b,color:#78281f,stroke-width:1.5px;
    class B1,B2,B3,B4,B5 bottleneck;
```

## ボトルネック詳細
| ID | 該当処理 | 現状 | 影響 |
|---|---|---|---|
| B1 | `getCallLogs` | `call_log` 全件 + `applicant/company/user` 全件を取得し、アプリ側で突合・フィルタ | データ増加時にレスポンス悪化（CPU/メモリ/転送量増） |
| B2 | `getApplicants`, `getApplicant` | JOINを使わず別クエリ＋`find`で突合 | 一覧・詳細ともに読取効率が落ちる |
| B3 | 応募者検索・企業名正規化検索 | `LIKE '%keyword%'` と `lower(trim(name))` 比較が中心 | indexが効きにくく、フルスキャン傾向 |
| B4 | 架電ログ登録 | `MAX(call_count)` 取得後に `INSERT`（トランザクション境界なし） | 同時書き込みで競合・採番重複リスク |
| B5 | D1物理設計 | FK/絞り込み/ソート列の補助indexが不足 | 一覧・集計・検索でスキャンコスト増 |

## 補足
- 現在の主経路は「ブラウザ -> Server Actions -> D1」と「Gmail -> GAS -> Inbound API -> D1」の2系統です。
- ボトルネックはコード構造に基づく現状分析であり、実運用ではアクセス量・件数に応じて顕在化します。
