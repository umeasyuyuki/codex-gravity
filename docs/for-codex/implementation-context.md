# Implementation Context

## 機能の実装状況 (V1)

1. **Next.js + Cloudflare Pages**: App Router を利用したプロジェクト構築と、Edge バインディングを通じたD1接続を実装（`src/db/index.ts` にて Proxy 経由で取得）。
2. **デザイン**: shadcn/ui と Tailwind を活用し、Glassmorphism(グラスモーフィズム) や柔らかなグラデーションを用いた Premium なUIを構成。
3. **認証**: NextAuth (Auth.js Beta) を利用し、Google OAuth（JWTセッション）を実装。DrizzleAdapter はビルド時の D1 Proxy 検証エラーを回避するため一旦切り離し JWT のみで保護。
4. **応募者画面**: ApplicantDetailClient コンポーネントにて歩留まりのフラグを useTransition + Server Action でリアルタイム更新できる仕組みを構築。
5. **歩留まり集計**: `aggregate` 代わりに Integer (bool) カラム群を `sum` するクエリを Action に実装して一括描画。

## 既知の課題 (Known Gaps)

- NextAuth DrizzleAdapter が `Proxy` オブジェクトをサポートしていないため、DB連動セッションの保存は見送った。ユーザー情報は OAuth ログイン直後に JWT に保持されるのみとしている。
- UIの各種フィルタ（表示期間・発生日起点等）は表示部品として実装しているが、バックエンドクエリとのフル連動（Date比較の詳細）はモックアップレベルであり細かい調整を要する。
