# GAS Inbound 連携手順（Advanced Gmail API版）

## 概要
- 目的: GmailのIndeed応募通知を構造化し、`/api/inbound/indeed` に転送してD1へ登録する。
- 実装方式: Apps Script（Advanced Gmail API + `UrlFetchApp`）。
- GCPの追加サービス（Cloud Run/PubSub/Secret Manager等）は使用しない。
- ただし Apps Script の Advanced Google services で Gmail API を有効化する必要がある。

## 使用ファイル
- GAS本体: `/Users/asyuyukiume/Projects/RPO_24CS/applier_trans.gs`
- 受信API: `/Users/asyuyukiume/Projects/RPO_24CS/my-project/rpo-app/src/app/api/inbound/indeed/route.ts`

## Apps Script 側の必須 Script Properties
- `RPO_API_URL`
  - 例: `https://<workers-url>/api/inbound/indeed`
- `RPO_API_KEY`
  - Cloudflare側 `INBOUND_API_KEY` と同じ値

## 事前設定（必須）
1. Apps Script エディタ -> `サービス` から `Gmail API` を追加（Advanced Google services）
2. 初回実行時の権限承認で Gmail 読み取りと外部通信を許可

## 実装時点の固定値
- `newer_than:7d`（過去7日）
- `pageSize:100`

## 運用ラベル
- `Indeed応募一覧/PROCESSED`
- `Indeed応募一覧/PARSE_ERROR`
- `Indeed応募一覧/API_ERROR`

## 実行順序
1. `dryRun()` を手動実行
2. ログで抽出内容（name/company/job/location/email）を確認
3. `run()` を手動実行
4. RPOアプリ側で応募者登録を確認
5. 同一メールを再実行して重複登録されないことを確認（`gmailMessageId` で冪等）
6. 時間トリガー（5分ごと推奨）を設定

## 失敗時の再処理
- `PARSE_ERROR`
  - メール本文フォーマット差異。パーサー修正が必要。
- `API_ERROR`
  - APIキー不一致 / API停止 / 一時通信失敗など。
  - 復旧後、`API_ERROR` ラベル対象を再処理。

## セキュリティ
- API認証は `x-rpo-api-key` ヘッダーで実施。
- `RPO_API_KEY` は Script Properties にのみ保存し、コード直書きしない。
