# Learning Report: init_app

- owner: Antigravity
- started_at: 2026-02-20
- report_path: docs/reports/init_app.md
- format: markdown
- update_rule: append-only to the same file

## Goal

- 採用代行業務のDXアプリ（歩留まり管理・架電履歴記録）のV1を初期構築する。
- スプレッドシート+GAS運用からの脱却を図り、高速・セキュア・拡張性のあるモダンなWebアプリケーション基盤を作る。

## Scope

- in_scope: 応募者一覧・詳細画面、企業一覧（歩留まり集計表）、架電ログ機能の構築、Google OAuth認証、Cloudflare D1データベース設計
- out_of_scope: CTI（電話システム）連携、企業ごとの選考フェーズカスタム機能

## Timeline

### 2026-02-20 - Phase 1 & 2: リサーチ & 要件定義

#### What changed

- 要件の深掘り質問を行い、アプリの必須機能と技術選定について合意した。
- Next.js + Cloudflare Pages + D1 + Google OAuth の構成を採用することを決定した。

#### Why this tech stack (for non-engineers)

- **Cloudflare Pages & D1**: 今回の要望（少人数利用だがデータ管理をしっかりしたい）に対し、完全無料で維持費がかからず、アクセスがない時にデータベースが停止するような制限もないため、業務利用に最適です。
- **Google OAuth**: 個人情報を扱うため、社内メンバーのGoogleアカウントで安全にログインできるようにします。

#### Must-check points for junior engineers

- RDB（リレーショナルデータベース）を利用するため、テーブル設計（Schema）で「応募者」「企業」「架電記録」のリレーション（関係性）をどう持たせるかがポイントになります。

#### References (Qiita/Zenn/Official)

- [Cloudflare D1 Docs](https://developers.cloudflare.com/d1/)

#### Next step

- データベースのスキーマ（テーブル構造）の設計と、Next.js等のフレームワーク初期化を進める。

### 2026-02-21 - Phase 5〜8: アプリ基盤・各機能実装完了

#### What changed

- Next.js + Cloudflare Pages + D1 によるバックエンド・フルスタックアプリの構築を完了した。
- Drizzle ORM を用いたDBスキーマ定義と、ローカルD1環境へのマイグレーションを実施。
- shadcn/ui と Tailwind CSS を活用し、Premiumなグラスモーフィズムデザインのダッシュボードを実装。
- Auth.js(v5) による Google OAuth (JWT) を導入し、ミドルウェアによるルート保護を設定。
- 応募者管理、歩留まり一覧（企業別）、架電ログ一覧の3大画面と、連動する Server Actions を構築。
- ユーザー要望による各種追加機能（面接日程のセット、企業からの遷移リンク、通電チェック等）を実装した。

#### Why this tech stack (for non-engineers)

- データベース（D1 / SQLiteベース）では、通常「はい/いいえ（boolean）」で扱う歩留まり関連のフラグを、「1/0（integer）」で保存する工夫をしました。これにより、企業ごとに「何人面接に進んだか？」といった集計をシンプルで高速な足し算（SUM）で行うことが可能になり、パフォーマンスと開発速度を両立させています。

#### Must-check points for junior engineers

- **Edge Runtime の制約とエラー対応**: Next.js App Router を Cloudflare で動かす際、`getRequestContext` などの Edge 専用 API を使うルートでは、必ず `export const runtime = "edge";` を明記しないとローカル・本番問わずエラーになる罠がある点に注意。
- **Adapter 非互換性への対応**: 今回、Auth.js の DrizzleAdapter が D1 バインディング用の `Proxy` オブジェクトの検査でエラーを吐きビルド失敗するという技術課題に直面。フルDB管理に固執せず、「セッションは JWT 側に持たせる」設計へ切り替えることでスピード解決を図った点は実務として重要な判断軸です。

#### References (Qiita/Zenn/Official)

- [Cloudflare: Deploy a Next.js site](https://developers.cloudflare.com/pages/framework-guides/nextjs/deploy-a-nextjs-site/)
- [NextAuth.js (Auth.js) v5 Beta Migration](https://authjs.dev/getting-started/migrating-to-v5)

#### Next step

- ワークフロー `@[/tdd]` に則り、TDDベースでの追加機能とUI改善（行クリック遷移、架電ログからの登録、歩留まり指標の詳細計算、サイドバーの折り畳み等）の設計と実装を進める。
