# 技術スタック調査と選定理由

## 採用技術スタック

- **Frontend / Framework**: Next.js (App Router) + React
- **Hosting / Edge Runtime**: Cloudflare Pages (`@cloudflare/next-on-pages`)
- **Database**: Cloudflare D1 (SQLiteベースのエッジRDB)
- **ORM**: Drizzle ORM
- **Authentication**: Auth.js (NextAuth.js v5) - Google OAuth
- **Styling**: Tailwind CSS / shadcn/ui

## 選定理由

1. **コストと運用負荷の削減**:
   - V1で利用人数（約10名）が少ないとはいえ業務利用のため、スリープ等が発生しない完全無料枠が強い Cloudflare D1 が最適。
   - Cloudflare Pages との組み合わせで、インフラの管理画面が一つにまとまり、運用が容易。
2. **認証の複雑さ回避**:
   - `Auth.js (NextAuth.js)` はEdge Runtime に対応しており、Cloudflare 上でも Googleログインを安全・簡単に実装可能。
3. **Drizzle ORM と D1 の相性の良さ**:
   - Drizzle ORMはエッジ環境やサーバーレス環境（特に Cloudflare D1）を公式に手厚くサポートしており、型安全な開発が可能。

## 代替案とその棄却理由

- **Supabase**: 無料枠では1週間アクセスがないとプロジェクトが一時停止(Pause)する仕様があり、業務利用でうっかり長期間操作しなかった際の復帰の手間を考慮して今回は不採用。
- **React (Vite) + Hono API**: 構成としては非常に綺麗だが、Next.jsを採用することで、ルーティングやSSR/SSGのエコシステム、Auth.jsの統合など開発速度の面でメリットが大きいと判断。
