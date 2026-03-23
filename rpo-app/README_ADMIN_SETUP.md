# 管理者制限とログイン設定：初めての人向け手順

このファイルは、今回追加した「管理者画面」「ログイン制限」の設定を、なるべくわかりやすくまとめたものです。  
難しい言葉はできるだけ避け、順番に進めればできます。

## 今回やったこと（ざっくり）
RPOアプリに「誰が使えるか（ログイン許可）」と  
「誰が管理者か」をメールアドレスで区別できるようにしました。

- 許可されたメールだけログインできる
- 管理者だけ「管理者画面」に入れる
- 応募者詳細の見出しを「2次/最終」→「2次面接」に変更

---

## まず必要な情報（3つ）
作業前にこの3つを用意します。

1. Googleログイン情報
   - `AUTH_GOOGLE_ID`
   - `AUTH_GOOGLE_SECRET`
2. 許可したいユーザーのメール
   - `LOGIN_ALLOWED_EMAILS`
3. 管理者ユーザーのメール（複数可）
   - `ADMIN_EMAILS`

---

## ステップ1：環境変数を設定

### 開発環境（ローカル）
`my-project/rpo-app/.env.local` を開いて、以下を追加します。  
※ 例のメールは自分のものに置き換えてください。

```bash
AUTH_GOOGLE_ID=YOUR_GOOGLE_CLIENT_ID
AUTH_GOOGLE_SECRET=YOUR_GOOGLE_CLIENT_SECRET

# カンマ区切りで複数指定
LOGIN_ALLOWED_EMAILS=admin@example.com, staff@example.com
ADMIN_EMAILS=admin@example.com

# GAS連携で使う場合
INBOUND_API_KEY=YOUR_SECRET_KEY
```

### 本番環境（Cloudflare）
本番は「Wrangler Secret / 変数」で同じ値をセットします。

```bash
npx wrangler secret put AUTH_GOOGLE_ID
npx wrangler secret put AUTH_GOOGLE_SECRET
npx wrangler secret put INBOUND_API_KEY
```

`LOGIN_ALLOWED_EMAILS` と `ADMIN_EMAILS` は公開値でもよいですが、  
情報管理の観点からここでもシークレットまたは vars で運用してください。

---

## ステップ2：DBの更新（新しい項目を反映）

先に実装したDB変更を本番DBにも反映します。

```bash
cd /Users/asyuyukiume/Projects/RPO_24CS
npx wrangler d1 migrations apply rpo-db --remote --config my-project/rpo-app/wrangler.jsonc
```

※ ローカル確認したい場合は `--local` にします。

反映後、必要なら確認：

```bash
npx wrangler d1 migrations list rpo-db --remote --config my-project/rpo-app/wrangler.jsonc
```

---

## ステップ3：アプリを起動/再デプロイ

### ローカル確認

```bash
cd /Users/asyuyukiume/Projects/RPO_24CS/my-project/rpo-app
npm run dev
```

### 本番反映（運用手順に合わせて）

```bash
npm run deploy
```

---

## ステップ4：動作確認（必ずやる）

### A. 一般ユーザー（許可あり）
1. Googleでログイン
2. `/admin` に直接入ろうとすると、管理者なら画面が見える
3. サイドバーに「管理者画面」が出る
4. 応募者詳細で「2次面接」に見える

### B. 許可外ユーザー
1. Googleでログイン試行
2. ログイン画面に `このメールアドレスはログイン許可されていません` の表示が出る
3. ダッシュボード画面へ進めない

### C. 管理者画面チェック
1. `/admin` にアクセスして、以下が見えることを確認  
   - ログイン中ユーザー情報  
   - `LOGIN_ALLOWED_EMAILS` の一覧  
   - `ADMIN_EMAILS` の一覧

---

## ステップ5：GAS連携を使う場合（本番URLを先に確定する）

`applier_trans.gs` は、Indeed応募メールを本サービスへ取り込むためのGASです。
ここで言う「API」は、あなたの `rpo-app` 側の受け取りエンドポイントです。

まず最初に、`/api/inbound/indeed` の公開URLが必要なので、**ここでは本番デプロイを1回行いURLを確定**してから進めます。

```bash
npm run deploy
```

デプロイ完了後に表示される Workers URL、または運用中のカスタムドメインを取得します。

- 受け取り先API: `POST https://<あなたの本番公開URL>/api/inbound/indeed`
- API実装ファイル: `my-project/rpo-app/src/app/api/inbound/indeed/route.ts`
- 認証ヘッダ: `x-rpo-api-key`
- 認証値: Cloudflare Secret の `INBOUND_API_KEY`

### A. まず「どこ」の値を決める

1. **本番URLを決める**
   - デプロイ後に決まる Workers URL
     例: `https://rpo-app.<account>.workers.dev`
   - カスタムドメインを使っている場合はそのドメイン
     例: `https://your-domain.com`
2. **受け取りAPI URLを作る**
   - 先ほどの本番URL + `/api/inbound/indeed`
   - 例: `https://your-domain.com/api/inbound/indeed`
3. **APIキーを決める**
   - `INBOUND_API_KEY=任意の長い文字列`（`.env.local` と Cloudflare Secret）

### B. GASの `Script properties` を設定

`applier_trans.gs` は次の2つを参照しています。

```bash
RPO_API_URL=<上で作った API エンドポイントURL>
RPO_API_KEY=<INBOUND_API_KEY と同じ文字列>
```

### C. GASの権限設定（事前）

1. GASに `applier_trans.gs` を読み込む
2. `Settings > Script properties` に `RPO_API_URL`, `RPO_API_KEY` を登録
3. 権限を許可
   - URLFetch
   - スクリプトを実行するGoogleアカウントの Gmail スコープ
   - **高度なサービス** → `Gmail API` を有効化

### D. 送信テスト

1. まず `dryRun()` を実行し、実データ送信しないで解析確認
2. `Logger.log` の以下を確認
   - 対象スレッドの抽出結果
   - 解析結果に `receivedAt/name/company/job/location/email` が入っていること
3. 問題がなければ `run()` を1回実行
4. 期待値
   - 実行ログに `Summary: OK=...`
   - 返信先メールスレッドに `Indeed応募一覧/PROCESSED` が付与

### E. 定期実行の前準備

1. 時間主導トリガーを作成（初回は1時間おきなど）
2. 運用監視
   - `parse` 失敗: `Indeed応募一覧/PARSE_ERROR`
   - API 失敗: `Indeed応募一覧/API_ERROR`

### F. 取り込まれたデータの反映先

`applicants` の重複は `gmailMessageId` で判定します。  
取り込み後は `applicants` / `companies` に反映されます。

- 応募者名、応募日時、職種、勤務地、メールアドレス
- 企業名（新しい企業は自動作成）

必要なら取り込み後の `applicants` / `companies` を管理画面で確認してください。

補足: 初回の疎通確認だけなら、固定キーで `curl` テストできます。

```bash
curl -X POST "https://あなたの本番公開URL/api/inbound/indeed" \
  -H "Content-Type: application/json" \
  -H "x-rpo-api-key: YOUR_SECRET_KEY" \
  -d '{"receivedAt":"2026-02-20T00:00:00.000Z","name":"テスト","company":"テスト企業","job":"エンジニア","location":"東京都","email":"test@example.com"}'
```

---

## よくあるミス（チェックポイント）

- メールのスペルミス  
  → 全角/半角、余計なスペースがないか確認  
- 区切り文字  
  → `LOGIN_ALLOWED_EMAILS` はカンマ区切り  
- 大文字小文字  
  → メールは小文字扱いで判定されますが、入力は小文字推奨  
- D1を更新していないまま確認する  
  → 503や想定外エラーの原因になりやすい  
- `.dev.vars` のみ編集して本番だけ放置  
  → 本番設定（Cloudflare）を別途更新してください

---

## ここまでで終わること

これで次の状態になります。

- 許可された人だけログイン可
- 許可された人のうち管理者だけ管理者画面へ入れる
- 応募者詳細の「2次/最終」は「2次面接」に変更済み

必要なら次は、この.mdに合わせた「運用ロールをUIで変更できる」版（GUIで追加・削除）も追加できます。
