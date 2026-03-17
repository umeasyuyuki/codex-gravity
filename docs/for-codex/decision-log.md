# Decision Log

| Date | Decision | Rationale | Alternatives Considered |
|---|---|---|---|
| 2026-02-21 | Cloudflare D1 Proxyの採用 | Next.js Edge 実行環境ではDBへのアクセスがリクエストコンテキスト(`env.DB`)内に限定されるため、トップレベルモジュールでDrizzleインスタンスを準備するため Proxy オブジェクトを採用。 | Request のたびに手動で db(context.env.DB) を渡す方法（記述が冗長になるため却下） |
| 2026-02-21 | NextAuth Adapter の不採用 | DrizzleAdapter が内部の `instanceof` 検証で Proxy オブジェクトを弾きビルドエラーになるため、今回は JWT を使ったセッション管理に限定し Adapter は外した。 | NextAuthに直接Cloudflare D1 HTTPドライバを渡すこと（ローカルとリモートの環境変数の取り回しが複雑になるため却下） |
| 2026-02-21 | boolean 代わりの integer カラム | D1（SQLite）は boolean 型がないため `integer({ mode: "boolean" })` を採用。これにより企業ごとの各フェーズ人数を `sum` クエリで直接一括集計可能になった。 | JSON型で丸ごと持たせること（集計パフォーマンスに影響するため不採用） |
