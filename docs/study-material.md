# RPO_24CS システムで学ぶ Web 開発入門

> 本教材は、実際に稼働している RPO（採用代行）業務管理システムを題材に、
> 駆け出しエンジニアが「実務で使う技術」を体系的に学べるよう構成しています。
> **JavaScript を読んだことがない人でも読み進められるよう、第0章でコードの読み方から解説しています。**

---

## 目次

0. [コードの読み方 ── JavaScript/TypeScript 超入門](#0-コードの読み方)
1. [はじめに ── このシステムは何をしているのか](#1-はじめに)
2. [全体アーキテクチャ ── システムの地図を読む](#2-全体アーキテクチャ)
3. [技術スタック解説 ── 使われている技術と「なぜそれを選んだか」](#3-技術スタック解説)
4. [フロントエンド編 ── 画面はどう作られているか](#4-フロントエンド編)
5. [バックエンド編 ── データはどう流れているか](#5-バックエンド編)
6. [データベース編 ── テーブル設計の考え方](#6-データベース編)
7. [認証・認可編 ── ログインの仕組み](#7-認証認可編)
8. [外部連携編 ── GAS による自動化パイプライン](#8-外部連携編)
9. [インフラ編 ── Cloudflare でのデプロイ](#9-インフラ編)
10. [コードリーディング演習](#10-コードリーディング演習)
11. [実践課題（手を動かす）](#11-実践課題)
12. [補足 ── よくある質問と用語集](#12-補足)

---

## 0. コードの読み方

> この章では、JavaScript / TypeScript のコードを **一度も読んだことがない人** を対象に、
> 本プロジェクトの実際のコードを使いながら「何が書いてあるか」を読み解く力を身につけます。
> プログラムを「書く」前に、まず「読める」ようになることが第一歩です。

### 0-1. プログラムは「上から下に読む文章」

プログラムは、基本的に **上の行から下の行へ順番に実行** されます。
日本語の文章を上から読むのと同じです。

本プロジェクトのコードを見てみましょう:

```typescript
// src/lib/userAccess.ts（7行目〜）より

function splitEmails(rawValue: string | undefined): string[] {
    if (!rawValue) {
        return []
    }

    return rawValue
        .replace(/\r/g, "")
        .replace(/\n/g, ",")
        .split(",")
        .map((value) => value.trim().toLowerCase())
        .filter(Boolean)
}
```

怖がらなくて大丈夫です。1 行ずつ日本語に「翻訳」してみましょう:

```
function splitEmails(rawValue: string | undefined): string[]
→「splitEmails という名前の処理を定義する。
   rawValue（生の値）を受け取って、string[]（文字列の配列）を返す」

if (!rawValue) { return [] }
→「もし rawValue が空だったら、空の配列を返して終了する」

return rawValue
    .replace(/\r/g, "")     → 「改行コード(\r)を消す」
    .replace(/\n/g, ",")    → 「改行(\n)をカンマに変える」
    .split(",")             → 「カンマで分割して配列にする」
    .map(...)               → 「各要素に処理を適用する」
    .filter(Boolean)        → 「空の要素を除外する」
```

**結果のイメージ:**
```
入力: "tanaka@example.com\nyamada@example.com"
      ↓ replace で改行をカンマに
      "tanaka@example.com,yamada@example.com"
      ↓ split でカンマで分割
      ["tanaka@example.com", "yamada@example.com"]
```

> **読み方のコツ:**
> 知らない単語が出てきても、関数名や変数名を **英語の意味** で読むと内容が推測できます。
> `splitEmails` → 「メールアドレスを分割する」、`rawValue` → 「生の値」

---

### 0-2. 記号の意味 ── これだけ覚えればコードが読める

プログラムには独特の記号がたくさん出てきます。
最初は暗号に見えますが、覚える記号は意外と少ないです。

#### 基本の記号

```
{ }    中カッコ     → 「ここからここまでが 1 つのまとまり」
( )    丸カッコ     → 「関数に渡す値」または「条件」
[ ]    角カッコ     → 「配列（データのリスト）」または「配列の何番目か」
;      セミコロン   → 「文の終わり」（省略されることも多い）
//     スラッシュ2つ → 「コメント（プログラムとして実行されないメモ）」
=      イコール1つ  → 「右の値を左に入れる（代入）」
===    イコール3つ  → 「左と右が同じか比較する」
!      ビックリマーク→ 「〜ではない（否定）」
=>     矢印         → 「関数の本体はこれです」
```

#### 実際のコードで確認しよう

```typescript
// src/middleware.ts より

export default auth((req) => {         // auth という関数に、別の関数を渡している
    if (req.auth?.user) {              // もし「ログイン済みのユーザー」がいたら
        return                         //   何もしない（そのまま通す）
    }                                  // ↑ ここまでが if の範囲

    const callbackPath = `${req.nextUrl.pathname}${req.nextUrl.search}`
    //    ↑ 変数を作る   ↑ テンプレート文字列（文字列の中に変数を埋め込む）

    const loginUrl = new URL("/login", req.nextUrl.origin)
    //    ↑ 新しい URL オブジェクトを作る

    loginUrl.searchParams.set("callbackUrl", callbackPath)
    //       ↑ URL に ?callbackUrl=xxx を追加する

    return NextResponse.redirect(loginUrl)
    //     ↑ ログインページにリダイレクト（転送）する
})

export const config = {
    matcher: ["/applicants/:path*", "/companies/:path*", "/calls/:path*"],
    // ↑ この middleware が適用される URL パターン
}
```

> **学習ポイント:**
> `?.` は **オプショナルチェーン** と呼ばれ、「もし左側が null/undefined なら、
> エラーにせずに undefined を返す」という安全装置です。
> `req.auth?.user` は「req.auth が存在すれば、その中の user を見る」という意味です。

---

### 0-3. 変数と型 ── データに名前をつけて、種類を宣言する

#### 変数の宣言

```typescript
const name = "田中太郎"      // const = 変わらない値（定数）
let age = 25                 // let   = あとで変わるかもしれない値
```

**const と let の使い分け:**
```
const → 一度決めたら変えない値に使う（こちらが圧倒的に多い）
let   → ループのカウンターなど、途中で値が変わるものに使う
```

#### TypeScript の「型」

JavaScript に **型（かた）** を追加したのが TypeScript です。
「この変数にはこの種類のデータしか入れません」と宣言します。

本プロジェクトの実際のコードで見てみましょう:

```typescript
// src/app/(dashboard)/applicants/ApplicantsTableClient.tsx（7行目〜）より

type Applicant = {
    id: string                              // 文字列
    name: string                            // 文字列
    age: number | null                      // 数値 または null（空）
    email: string | null                    // 文字列 または null
    isValidApplicant: boolean | null        // true/false または null
    appliedAt: string | number | Date       // 文字列 or 数値 or 日付
}
```

これを日本語に翻訳すると:

```
type Applicant = {        →「Applicant（応募者）というデータの形を定義する」
    id: string            →「id は文字列です」
    name: string          →「name は文字列です」
    age: number | null    →「age は数値です。ただし空（null）の場合もあります」
    email: string | null  →「email は文字列です。ただし空の場合もあります」
    isValidApplicant: boolean | null
                          →「isValidApplicant は true か false です。空もあり得ます」
}
```

**よく使う型:**

```
string    → 文字列     "田中太郎", "tanaka@example.com"
number    → 数値       25, 3.14, -1
boolean   → 真偽値     true（はい）, false（いいえ）
null      → 空         データがないことを明示
undefined → 未定義     まだ何も設定されていない
string[]  → 文字列の配列  ["田中", "山田", "佐藤"]
```

> **読み方のコツ:**
> `|` は「または」と読みます。
> `string | null` → 「文字列 または null」
> `string | number | Date` → 「文字列 または 数値 または 日付」

---

### 0-4. 関数 ── 「処理のまとまり」に名前をつける

関数は、**繰り返し使う処理をまとめて名前をつけたもの** です。
料理のレシピに例えると、「カレーの作り方」という名前のついた手順書です。

#### 関数の 3 つの書き方

このプロジェクトでは主に 3 つの書き方が使われています:

```typescript
// ① function 宣言（伝統的な書き方）
// src/app/(dashboard)/applicants/ApplicantsTableClient.tsx（113行目〜）より

function calcAge(dateValue: string | number | Date | null | undefined) {
    if (!dateValue) return "-"
    const birth = new Date(dateValue)
    if (Number.isNaN(birth.getTime())) return "-"
    const today = new Date()
    let age = today.getFullYear() - birth.getFullYear()
    const monthDiff = today.getMonth() - birth.getMonth()
    const dayDiff = today.getDate() - birth.getDate()
    if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
        age -= 1
    }
    return age >= 0 ? String(age) : "-"
}
```

1 行ずつ読んでみましょう:

```
function calcAge(dateValue: ...)       → 「年齢を計算する関数。生年月日を受け取る」
    if (!dateValue) return "-"         → 「生年月日がなければ "-" を返して終了」
    const birth = new Date(dateValue)  → 「生年月日を Date オブジェクトに変換」
    const today = new Date()           → 「今日の日付を取得」
    let age = today.getFullYear() - birth.getFullYear()
                                       → 「年の差を計算（暫定の年齢）」
    const monthDiff = ...              → 「月の差を計算」
    if (monthDiff < 0 || ...)          → 「誕生日がまだ来ていなければ」
        age -= 1                       → 「年齢を 1 引く」
    return age >= 0 ? String(age) : "-"
        → 「0歳以上なら文字列にして返す。そうでなければ "-"」
```

```typescript
// ② アロー関数（=> を使う現代的な書き方）
// src/lib/userAccess.ts（29行目〜）より

function normalizeEmail(value: string | null | undefined) {
    if (!value) return null
    return value.trim().toLowerCase()
}
//                  ↓ これをアロー関数で書くと
const normalizeEmail = (value: string | null | undefined) => {
    if (!value) return null
    return value.trim().toLowerCase()
}
```

```typescript
// ③ コールバック（関数の中に関数を渡す）
// src/app/(dashboard)/applicants/ApplicantsTableClient.tsx（36行目〜）より

const callLogsWithUser = callLogs.map((log) => ({
    ...log,
    callerName: log.callerName || "Unknown",
}))
```

これを日本語に:
```
callLogs           → 「架電ログの配列」
.map(              → 「それぞれの要素に対して以下を実行する」
  (log) =>         → 「各要素を log という名前で受け取って」
  ({               → 「新しいオブジェクトを作る」
    ...log,        → 「元の log の全データをコピーして」
    callerName: log.callerName || "Unknown"
                   → 「callerName がなければ "Unknown" にする」
  })
)
```

> **学習ポイント:**
> `...` は **スプレッド構文** と呼ばれます。
> `...log` は「log の中身をすべて展開する」という意味です。
> コピーしつつ一部を上書きするときによく使います。

---

### 0-5. import / export ── ファイル間の「部品の受け渡し」

大きなプログラムは 1 つのファイルに全部書くのではなく、
**機能ごとにファイルを分けて、必要なものだけ受け渡し** します。

```typescript
// src/middleware.ts（1〜2行目）より

import { NextResponse } from "next/server"    // ← 外部ライブラリから借りる
import { auth } from "@/auth"                 // ← 自分のプロジェクトの別ファイルから借りる
```

```
import { NextResponse } from "next/server"

  import    → 「借りてくる」
  { NextResponse }  → 「NextResponse という部品を」
  from "next/server" → 「next/server というライブラリから」
```

**export は「貸し出す」側:**

```typescript
// src/lib/userAccess.ts（34行目〜）より

export function isLoginAllowed(email: string | null | undefined) {
    // ...
}
```

```
export   → 「他のファイルからも使えるようにする」
function isLoginAllowed(...) → 「isLoginAllowed という関数を定義する」
```

**import パスの読み方:**

```
"next/server"           → npm パッケージ（node_modules の中）
"@/auth"                → 自分のプロジェクトの src/auth.ts（@ は src/ のショートカット）
"@/lib/actions/applicant" → src/lib/actions/applicant.ts
"./CompanyFilterSelect"   → 同じフォルダの CompanyFilterSelect.tsx
"../components/Button"    → 1 つ上のフォルダの components/Button.tsx
```

> **学習ポイント:**
> `@/` は **パスエイリアス** と呼ばれ、このプロジェクトでは `src/` を指しています。
> `../../lib/actions` のように `../` を連打する代わりに `@/lib/actions` と書けて便利です。

---

### 0-6. async / await ── 「待つ処理」の書き方

Web アプリでは「データベースからデータを取ってくる」「API を呼ぶ」など、
**時間がかかる処理** がたくさんあります。
`async/await` は「その処理が終わるまで待つ」仕組みです。

```typescript
// src/lib/actions/applicant.ts（9行目〜）より

export async function getApplicant(id: string) {
    const applicantId = id?.trim()
    if (!applicantId) {
        return null
    }

    const applicant = await db
        .select()
        .from(schema.applicants)
        .where(eq(schema.applicants.id, applicantId))
        .get();

    if (!applicant) return null;

    const [company, interviews, callLogs] = await Promise.all([
        db.select().from(schema.companies).where(eq(schema.companies.id, applicant.companyId)).get(),
        db.select().from(schema.interviews).where(eq(schema.interviews.applicantId, applicantId)).all(),
        db.select().from(schema.callLogs)
          .leftJoin(schema.users, eq(schema.callLogs.callerId, schema.users.id))
          .where(eq(schema.callLogs.applicantId, applicantId))
          .all(),
    ]);

    return { ...applicant, company, interviews, callLogs };
}
```

日本語に翻訳:

```
async function getApplicant(id)
→「getApplicant は時間がかかる処理を含む関数です（asyncが目印）」

const applicant = await db.select()...
→「DB に問い合わせて、結果が返ってくるまで "待つ"（await）」

const [company, interviews, callLogs] = await Promise.all([...])
→「3 つの DB 問い合わせを "同時に" 実行して、全部終わるまで待つ」
→ 1 つずつ順番に待つより速い！
```

**async/await がないとどうなるか:**

```
普通のコード:
  const data = getDataFromDB()   ← DB から返ってくる前に次の行に進んでしまう
  console.log(data)              ← まだ data が入っていない！

async/await:
  const data = await getDataFromDB()  ← DB の結果が来るまで待つ
  console.log(data)                   ← ちゃんと data が入っている
```

> **学習ポイント:**
> `async` は「この関数には待つ処理が含まれますよ」という宣言。
> `await` は「ここで結果が来るまで待ってね」という指示。
> この 2 つはいつもセットで使います。

---

### 0-7. JSX ── JavaScript の中に HTML を書く

React（このプロジェクトの UI ライブラリ）では、
**JavaScript のコード中に HTML のような記法で画面の見た目を書き** ます。
これを **JSX** と呼びます。

```tsx
// src/app/(dashboard)/applicants/page.tsx（32行目〜）の一部を抜粋

return (
    <div className="space-y-6">
        <div className="flex items-center justify-between">
            <div>
                <h1 className="text-3xl font-bold">応募者管理</h1>
                <p className="text-sm">選考ステータスや面接日程を管理します</p>
            </div>
            <button className="bg-primary text-white px-4 py-2 rounded">
                <Plus className="w-4 h-4" />
                新規登録
            </button>
        </div>
    </div>
)
```

**HTML を知っている人向け:** ほぼ HTML と同じですが、以下が異なります:

```
HTML の場合:            JSX の場合:
<div class="...">       <div className="...">     ← class → className
<label for="name">      <label htmlFor="name">    ← for → htmlFor
<img src="..." />       <img src="..." />         ← 同じ（閉じタグ必須）
```

**HTML を知らない人向け:** JSX は **画面の構造をタグで書く仕組み** です:

```
<div>        → 箱（グループ化するための入れ物）
<h1>         → 見出し（大きな文字）
<p>          → 段落（普通の文章）
<button>     → ボタン
<input>      → 入力欄
<table>      → 表
<tr>         → 表の行
<td>         → 表のセル
<select>     → ドロップダウンメニュー
<option>     → ドロップダウンの選択肢
<form>       → フォーム（入力欄のまとまり）
<a> / <Link> → リンク
```

#### JSX の中で JavaScript を使う ── `{ }` の意味

JSX の中で `{ }` を使うと、**JavaScript の値や処理を埋め込め** ます:

```tsx
// src/app/(dashboard)/applicants/ApplicantsTableClient.tsx（193行目〜）より

<td className="px-3 py-2">
    {toInputDateValue(row.appliedAt) || "-"}
</td>
```

```
{toInputDateValue(row.appliedAt) || "-"}

{ }   → 「ここからは JavaScript の世界ですよ」
toInputDateValue(row.appliedAt)  → 「応募日を表示用に変換した結果」
||    → 「もし左が空なら」
"-"   → 「代わりにハイフンを表示」
```

もう 1 つ、条件による表示切り替え:

```tsx
// 同ファイル 218行目〜 より

{isResponseEmpty && (
    <span className="bg-red-100 text-red-700">
        新着
    </span>
)}
```

```
{isResponseEmpty && (...)}

isResponseEmpty   → 「対応状況が未記入か？」
&&                → 「もしそうなら」
<span>新着</span> → 「"新着" バッジを表示する」

つまり: 「対応状況が空のときだけ "新着" と表示する」
```

> **学習ポイント:**
> `&&` は **短絡評価** と呼ばれるテクニックです。
> `条件 && 表示内容` で「条件が true のときだけ表示」を実現します。
> if 文を使わずに条件つき表示ができるので、JSX では頻出のパターンです。

---

### 0-8. 三項演算子 ── 「もし A なら B、そうでなければ C」を 1 行で

```tsx
// src/app/(dashboard)/applicants/page.tsx（107行目）より

{total === 0 ? "0件" : `${totalFrom}〜${totalTo}件 / 全${total}件`}
```

```
条件 ? 真のとき : 偽のとき

total === 0        → 「件数が 0 なら」
? "0件"            → 「"0件" と表示」
: `${totalFrom}〜${totalTo}件 / 全${total}件`
                   → 「そうでなければ "1〜50件 / 全340件" のように表示」
```

もう 1 つの例:

```tsx
// 同ファイル 110行目〜 より

{prevPage ? (
    <Link href={buildPageUrl(prevPage)}>前へ</Link>
) : (
    <span className="text-muted-foreground">前へ</span>
)}
```

```
prevPage ?       → 「前のページがあるなら」
  <Link ...>     → 「クリックできるリンクとして表示」
:                → 「前のページがないなら」
  <span ...>     → 「グレーアウトした文字として表示（クリック不可）」
```

---

### 0-9. オブジェクトと配列 ── データの入れ物

#### オブジェクト ── 名前付きデータのまとまり

```typescript
// src/app/(dashboard)/applicants/ApplicantsTableClient.tsx（43行目〜）より

const STATUS_OPTIONS = [
    { value: "", label: "選考状況を選択してください" },
    { value: "初回連絡前", label: "初回連絡前" },
    { value: "連絡中", label: "連絡中" },
    { value: "面接調整中", label: "面接調整中" },
    { value: "対応完了", label: "対応完了" },
]
```

```
STATUS_OPTIONS は「オブジェクトの配列」:
  [ ]  → 配列（リスト）
  { }  → オブジェクト（名前付きデータのまとまり）

1 つ目の要素: { value: "", label: "選考状況を選択してください" }
  → value という名前のデータ: ""（空文字）
  → label という名前のデータ: "選考状況を選択してください"
```

#### 配列の操作メソッド

```typescript
// src/lib/userAccess.ts（13行目〜）より

return rawValue
    .replace(/\r/g, "")        // 全体に対する文字列置換
    .replace(/\n/g, ",")
    .split(",")                // カンマで分割 → 配列になる
    .map((value) => value.trim().toLowerCase())
                               // 各要素を加工した新しい配列を作る
    .filter(Boolean)           // 空の要素を取り除く
    .filter((value, index, values) => values.indexOf(value) === index)
                               // 重複を取り除く
```

**よく使う配列メソッド（この表を手元に置いておくと便利）:**

```
.map(fn)      → 各要素に fn を適用して、新しい配列を返す
               [1,2,3].map(x => x * 2)  →  [2,4,6]

.filter(fn)   → fn が true を返す要素だけ残す
               [1,2,3,4].filter(x => x > 2)  →  [3,4]

.find(fn)     → fn が true を返す最初の要素を返す
               [1,2,3].find(x => x > 1)  →  2

.includes(x)  → 配列に x が含まれるか
               ["a","b","c"].includes("b")  →  true

.split(sep)   → 文字列を sep で分割して配列にする（文字列のメソッド）
               "a,b,c".split(",")  →  ["a","b","c"]

.join(sep)    → 配列を sep で結合して文字列にする
               ["a","b","c"].join("-")  →  "a-b-c"
```

---

### 0-10. `"use client"` と `"use server"` ── ファイルの 1 行目に注目

このプロジェクトで特に重要なのが、ファイルの **最初の 1 行** です。
ここに書かれた宣言で、そのファイルの役割が決まります。

```typescript
// パターン 1: 何も書いていない → Server Component（サーバーで実行）
// src/app/(dashboard)/applicants/page.tsx
export default async function ApplicantsPage({ searchParams }) {
    const applicants = await getApplicants(...)  // DB に直接アクセスできる
    return <ApplicantsTableClient applicants={applicants} />
}
```

```typescript
// パターン 2: "use client" → Client Component（ブラウザで実行）
// src/app/(dashboard)/applicants/ApplicantsTableClient.tsx
"use client"

export default function ApplicantsTableClient({ applicants }) {
    const [rows, setRows] = useState(applicants)  // ← 状態管理ができる
    // ユーザーの操作（クリック、入力）を処理する
}
```

```typescript
// パターン 3: "use server" → Server Action（サーバーで実行される関数）
// src/lib/actions/applicant.ts
"use server"

export async function updateApplicant(id, data) {
    await db.update(schema.applicants).set(data)...  // ← DB を直接更新
    revalidatePath("/applicants")  // ← 画面を再読み込みさせる
}
```

**図にすると:**

```
┌─── ブラウザ（ユーザーの PC）──────────────────────┐
│                                                   │
│  "use client" のファイル                          │
│  → ボタンクリック、入力、表示の切り替え            │
│  → useState, onClick が使える                     │
│  → DB に直接アクセスできない                      │
│                                                   │
└──────────┬────────────────────────────────────────┘
           │ ユーザーが操作すると...
           │ Server Action を呼ぶ or ページ遷移
           ▼
┌─── サーバー（Cloudflare Workers）────────────────┐
│                                                   │
│  何も書いていないファイル（Server Component）      │
│  → DB からデータを取得して HTML を生成             │
│                                                   │
│  "use server" のファイル（Server Action）         │
│  → DB の更新・削除などを実行                      │
│                                                   │
└──────────────────────────────────────────────────┘
```

> **学習ポイント:**
> コードを読むとき、**最初にファイルの 1 行目を確認する** 習慣をつけましょう。
> `"use client"` → ブラウザで動くコード → ユーザー操作系
> `"use server"` → サーバーで動くコード → DB 操作系
> この判断ができるだけで、ファイルの役割が一瞬で分かります。

---

### 0-11. よく見る記号・パターン 早見表

コードを読んでいて「これ何？」と思ったらここを見てください。

```
?.           オプショナルチェーン   null でもエラーにならない
             user?.name → user があれば name、なければ undefined

??           Null 合体演算子       左が null/undefined なら右を使う
             name ?? "名無し" → name があれば name、なければ "名無し"

||           OR（または）          左が falsy なら右を使う
             email || "-" → email があれば email、なければ "-"

&&           AND（かつ）           左が true なら右を返す
             isNew && <Badge /> → isNew が true ならバッジを表示

!            NOT（否定）           true → false、false → true
             !value → value が空なら true

!!           二重否定              値を true/false に変換
             !!user → user がいれば true

...          スプレッド構文        中身を展開する
             { ...obj, name: "new" } → obj をコピーして name を上書き

`${x}`       テンプレートリテラル  文字列に変数を埋め込む
             `こんにちは${name}さん` → "こんにちは田中さん"

=>           アロー関数            関数の短い書き方
             (x) => x * 2 → x を 2 倍にする関数

<T>          ジェネリクス          型のパラメータ（今は読み飛ばして OK）

as           型アサーション        「この値はこの型です」と宣言
             payload as Record<string, unknown>

typeof       型チェック            値の型を調べる
             typeof value === "string" → value が文字列かどうか
```

---

### 0-12. 実際のコードを読んでみよう ── 総合練習

ここまで学んだ知識を使って、実際のコードを読み解いてみましょう。

#### 練習問題: API キー認証

```typescript
// src/app/api/inbound/indeed/route.ts（20行目〜）より抜粋

export async function POST(request: NextRequest) {
    const configuredApiKey = getRuntimeEnv(API_KEY_ENV_NAME)

    if (!configuredApiKey) {
        return NextResponse.json(
            { success: false, error: "INBOUND_API_KEY is not configured" },
            { status: 500 }
        )
    }

    const providedApiKey = request.headers.get(API_KEY_HEADER)?.trim()
    if (!providedApiKey || providedApiKey !== configuredApiKey) {
        return NextResponse.json(
            { success: false, error: "Invalid API key" },
            { status: 401 }
        )
    }

    // ...この先は認証を通過したリクエストだけが到達する
}
```

**問題: このコードは何をしていますか？ 自分の言葉で説明してみてください。**

<details>
<summary>解答を見る</summary>

```
1. getRuntimeEnv(API_KEY_ENV_NAME)
   → サーバーに設定されている正しい API キーを取得する

2. if (!configuredApiKey)
   → もし正しい API キーがサーバーに設定されていなければ
   → 500 エラー（サーバー側の設定ミス）を返す

3. request.headers.get(API_KEY_HEADER)?.trim()
   → リクエストのヘッダーから、送り手が付けた API キーを取り出す
   → ?.trim() で前後の空白を除去する

4. if (!providedApiKey || providedApiKey !== configuredApiKey)
   → API キーが送られていない、または正しくない場合
   → 401 エラー（認証失敗）を返す

5. ここを通過したリクエストは、正しい API キーを持っている
   → 安全なので、応募者データの登録に進める
```

</details>

#### 練習問題: 環境変数の読み込み

```typescript
// src/lib/runtime-env.ts（3行目〜）より

export function getRuntimeEnv(name: string): string | undefined {
    const processEnv = readFromProcess(name)
    if (processEnv !== undefined) return processEnv

    const cloudflareEnv = readFromCloudflareContext(name)
    if (cloudflareEnv !== undefined) return cloudflareEnv

    const globalEnv = readFromGlobalContext(name)
    if (globalEnv !== undefined) return globalEnv

    return undefined
}
```

**問題: この関数はなぜ 3 つの場所を順番に確認しているのでしょうか？**

<details>
<summary>解答を見る</summary>

```
このシステムは「ローカル開発環境」と「本番環境（Cloudflare Workers）」の
2 つの異なる環境で動きます。環境変数の取得方法が環境ごとに異なるため、
3 つの方法を順番に試しています:

1. readFromProcess → ローカル開発時（Node.js の process.env）
2. readFromCloudflareContext → 本番環境（Cloudflare Workers のバインディング）
3. readFromGlobalContext → その他のランタイム

「最初に見つかったものを返す」という "フォールバック" パターンです。
どの環境で動いても同じコードで動作するように設計されています。
```

</details>

---

### 0-13. コードを読む 5 つの習慣

ここまでの内容を踏まえて、コードリーディングの習慣をまとめます。

```
習慣 1: ファイルの 1 行目を見る
  → "use client" / "use server" / 何もなし で役割を判断

習慣 2: import 文を見る
  → そのファイルが何に依存しているかが分かる
  → DB を使っている？ 認証を使っている？ UI ライブラリを使っている？

習慣 3: export されている関数名を見る
  → そのファイルの「公開 API」が分かる
  → 関数名から処理内容を推測する（getApplicant → 応募者を取得する）

習慣 4: 分からない記号は「早見表」を引く
  → 0-11 の早見表を手元に置いておく
  → 慣れれば自然と読めるようになる

習慣 5: 「入力 → 処理 → 出力」の流れで読む
  → 関数の引数（入力）は何か？
  → 中で何をしているか？
  → 何を return しているか（出力）？
  → この 3 点だけ押さえれば大筋は理解できる
```

> **この章を終えたあなたへ:**
> ここまで読めたなら、次の第 1 章以降に出てくるコードも怖くありません。
> 分からない部分が出てきたら、この章に戻って確認してください。
> コードは読めば読むほど慣れていきます。最初はゆっくりで大丈夫です。

---

## 1. はじめに

### 1-1. このシステムの目的

RPO_24CS は **採用代行（RPO: Recruitment Process Outsourcing）** の業務を管理するシステムです。

**解決する課題:**

- 26 社以上のクライアント企業から Indeed 経由で届く応募を手作業で管理していた
- 応募者の選考状況（書類選考 → 一次面接 → 最終面接 → 内定 → 入社）が Google スプレッドシートに散在
- 「どの企業にどれだけ応募が来て、何人が入社したか」の分析（歩留まり分析）に時間がかかっていた

**このシステムが提供するもの:**

| 機能 | 概要 |
|---|---|
| 応募者管理 | 一覧・検索・ステータス更新をブラウザから |
| 架電記録 | 誰がいつ電話し、つながったかを記録 |
| 歩留まり分析 | 企業別・月別の選考ファネル（漏斗）を可視化 |
| Indeed 自動取り込み | メールで届く応募を自動で DB に登録 |
| スプレッドシート同期 | DB のデータを 26 社分のシートへ自動反映 |

### 1-2. 学べること

この教材を通じて、以下を身につけます:

- **フルスタック Web アプリの全体像** を理解する力
- **Next.js App Router** の実践的な使い方
- **Server Actions / API Routes** によるバックエンド実装
- **Drizzle ORM + SQLite** でのデータベース操作
- **NextAuth.js** による Google ログイン実装
- **Cloudflare Workers + D1** でのエッジデプロイ
- **Google Apps Script** を使った外部連携の自動化
- 実務のコードを読み解く **コードリーディング力**

---

## 2. 全体アーキテクチャ

### 2-1. システム構成図

```
                         ┌─────────────────────────────────────────┐
                         │            Cloudflare Workers            │
                         │  ┌─────────────────────────────────┐    │
  ブラウザ ─────────────►│  │     Next.js App (SSR + API)     │    │
  （RPO担当者）          │  │  ┌──────────┐  ┌─────────────┐  │    │
                         │  │  │ React UI │  │ Server      │  │    │
                         │  │  │ (画面)   │  │ Actions/API │  │    │
                         │  │  └──────────┘  └──────┬──────┘  │    │
                         │  └───────────────────────┼─────────┘    │
                         │                          │              │
                         │                   ┌──────▼──────┐       │
                         │                   │ Cloudflare  │       │
                         │                   │ D1 (SQLite) │       │
                         │                   └──────┬──────┘       │
                         └──────────────────────────┼──────────────┘
                                                    │
                    ┌───────────────────────────────┼───────────────┐
                    │                               │               │
          ┌─────────▼──────────┐          ┌────────▼─────────┐     │
          │  applier_trans.gs  │          │ db_to_spreadsheet │     │
          │  (Indeed→DB取込)   │          │ _sync.gs          │     │
          │                    │          │ (DB→シート同期)   │     │
          └────────┬───────────┘          └────────┬─────────┘     │
                   │                               │               │
          ┌────────▼───────┐             ┌─────────▼────────┐      │
          │  Gmail         │             │ Google Sheets     │      │
          │ (Indeed通知)   │             │ (26社分)         │      │
          └────────────────┘             └──────────────────┘      │
```

### 2-2. データの流れ（ライフサイクル）

```
① Indeed で求職者が応募
     ↓
② Indeed から Gmail に通知メール到着
     ↓
③ applier_trans.gs がメールを解析 → /api/inbound/indeed へ POST
     ↓
④ API が応募者データを D1 データベースに保存
     ↓
⑤ RPO 担当者がブラウザで応募者を確認・ステータス更新・架電記録
     ↓
⑥ db_to_spreadsheet_sync.gs が定期的にDBからデータ取得
     ↓
⑦ 各クライアント企業の Google スプレッドシートを更新
```

> **学習ポイント:**
> 実務のシステムは「1 つのアプリ」で完結しないことが多いです。
> メール → GAS → API → DB → GAS → スプレッドシートという **パイプライン** の考え方は、
> あらゆるシステム設計で登場します。

---

## 3. 技術スタック解説

### 3-1. 使用技術の一覧

| カテゴリ | 技術 | バージョン | 役割 |
|---|---|---|---|
| **フレームワーク** | Next.js | 16.1.5 | React ベースのフルスタックフレームワーク |
| **UI ライブラリ** | React | 19.1.5 | コンポーネントベースの UI 構築 |
| **言語** | TypeScript | 5.7.4 | 型安全な JavaScript |
| **CSS** | Tailwind CSS | 4.0 | ユーティリティファーストの CSS |
| **UI 部品** | shadcn/ui + Radix UI | - | アクセシブルな UI コンポーネント |
| **フォーム** | React Hook Form + Zod | 7.71 / 4.3 | フォーム管理とバリデーション |
| **ORM** | Drizzle ORM | 0.45.1 | 型安全な SQL クエリビルダー |
| **DB** | Cloudflare D1 (SQLite) | - | エッジで動くリレーショナル DB |
| **認証** | NextAuth.js v5 | beta.30 | Google OAuth 2.0 ログイン |
| **ホスティング** | Cloudflare Workers | - | エッジコンピューティング |
| **外部連携** | Google Apps Script | - | メール解析・シート同期の自動化 |
| **テスト** | Vitest | 3.2.4 | 高速ユニットテスト |

### 3-2. なぜこの技術を選んだのか？

#### Next.js を選んだ理由

```
❌ 素の React (SPA)
   → SEO は不要だが、サーバーサイドで DB に直接アクセスしたい
   → API サーバーを別に立てるのは管理コストが増える

❌ Express.js + React
   → フロントとバックを別々にデプロイ・管理する必要がある

✅ Next.js (App Router)
   → 1 つのプロジェクトでフロント＋バックを一体管理
   → Server Actions で API レイヤーを省略し、直接 DB 操作
   → SSR で初期表示が速い
```

#### Cloudflare D1 (SQLite) を選んだ理由

```
❌ PostgreSQL (Supabase, Neon など)
   → 10人程度の利用には過剰。接続プーリングの管理が必要

❌ MySQL
   → 同上。サーバー管理が必要

✅ Cloudflare D1 (SQLite)
   → サーバーレス。管理不要
   → Workers と同じエッジで動くのでレイテンシがほぼゼロ
   → 10人・数千〜数万レコード規模には十分
   → ローカル開発は better-sqlite3 で互換動作
```

#### Drizzle ORM を選んだ理由

```
❌ Prisma
   → Cloudflare Workers 上で動かすのに制約が多い
   → 型生成にビルドステップが必要

✅ Drizzle ORM
   → Cloudflare D1 をネイティブサポート
   → TypeScript の型がスキーマ定義から自動推論される
   → SQL に近い API なので学習コストが低い
```

> **学習ポイント:**
> 技術選定は「最新・最強だから」ではなく、 **「チーム規模・ユーザー数・運用コスト」に合っているか** で判断します。
> このシステムは 10 人のオペレーター向けなので、シンプルさと運用コストの低さが重視されています。

---

## 4. フロントエンド編

### 4-1. Next.js App Router のディレクトリ構造

```
src/app/
├── (dashboard)/              ← Route Group: ログイン必須の画面群
│   ├── layout.tsx            ← 共通レイアウト（サイドバー）
│   ├── applicants/           ← 応募者管理
│   │   ├── page.tsx          ← 一覧ページ
│   │   └── [id]/page.tsx     ← 詳細ページ（動的ルーティング）
│   ├── companies/            ← 企業・歩留まり管理
│   │   └── page.tsx
│   ├── calls/                ← 架電管理
│   │   ├── history/page.tsx
│   │   ├── register/page.tsx
│   │   └── analysis/page.tsx
│   └── admin/                ← 管理画面
│       └── sheets/page.tsx
├── api/                      ← API エンドポイント
├── login/page.tsx            ← ログインページ
├── layout.tsx                ← ルートレイアウト
└── page.tsx                  ← / にアクセスしたら /applicants へリダイレクト
```

### 4-2. 重要な概念: Server Components vs Client Components

Next.js App Router 最大の特徴は **Server Components（サーバーコンポーネント）** です。

```
┌──────────────────────────────────────────────────┐
│              Server Component (デフォルト)          │
│                                                    │
│  ・サーバー上で実行される                            │
│  ・DB に直接アクセスできる                           │
│  ・ブラウザには HTML だけ送られる（JS が少ない）      │
│  ・useState, onClick は使えない                     │
│                                                    │
│  例: page.tsx で DB からデータ取得 → HTML 生成       │
└──────────────┬───────────────────────────────────┘
               │ props でデータを渡す
               ▼
┌──────────────────────────────────────────────────┐
│              Client Component ("use client")       │
│                                                    │
│  ・ブラウザ上で実行される                            │
│  ・useState, useEffect, onClick が使える            │
│  ・インタラクティブな UI を担当                      │
│  ・DB に直接アクセスできない                         │
│                                                    │
│  例: ApplicantsTableClient.tsx（テーブルの操作）     │
└──────────────────────────────────────────────────┘
```

#### 実際のコードで見てみよう

**Server Component（データ取得担当）** — `src/app/(dashboard)/applicants/page.tsx`

```typescript
// "use client" がない = Server Component
export default async function ApplicantsPage({ searchParams }) {
  // サーバー上で直接 DB にアクセス
  const applicants = await getApplicants(page, companyId, search);
  const companies = await getCompanies();

  // 取得したデータを Client Component に渡す
  return (
    <ApplicantsTableClient
      applicants={applicants}
      companies={companies}
    />
  );
}
```

**Client Component（ユーザー操作担当）** — `ApplicantsTableClient.tsx`

```typescript
"use client"; // ← これが Client Component の印

export function ApplicantsTableClient({ applicants, companies }) {
  const [search, setSearch] = useState("");  // ← Server Component では使えない

  return (
    <input
      value={search}
      onChange={(e) => setSearch(e.target.value)}  // ← ユーザー操作
    />
    // ...テーブル表示
  );
}
```

> **学習ポイント:**
> Server Component でデータを取得し、Client Component でインタラクションを処理する。
> この **「データ取得は Server、操作は Client」** という分離パターンを覚えましょう。

### 4-3. shadcn/ui ── UI コンポーネントの使い方

このプロジェクトでは `shadcn/ui` という UI ライブラリを使っています。
Bootstrap のように「全部入り」ではなく、**必要なコンポーネントだけコピーして使う** のが特徴です。

```
src/components/ui/
├── button.tsx      ← ボタン
├── card.tsx        ← カード
├── table.tsx       ← テーブル
├── input.tsx       ← 入力欄
├── select.tsx      ← セレクトボックス
├── form.tsx        ← フォーム
├── checkbox.tsx    ← チェックボックス
├── dropdown-menu.tsx
└── label.tsx
```

コード内ではこのように使われます:

```tsx
import { Button } from "@/components/ui/button";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";

<Card>
  <CardHeader>
    <CardTitle>応募者一覧</CardTitle>
  </CardHeader>
  <CardContent>
    <Button onClick={handleClick}>検索</Button>
  </CardContent>
</Card>
```

> **学習ポイント:**
> shadcn/ui は **Radix UI**（アクセシビリティに優れたヘッドレスコンポーネント）+
> **Tailwind CSS**（スタイル）の組み合わせです。
> 「見た目のないロジック部品」と「見た目を付けるスタイル」を分離する考え方を学べます。

### 4-4. Tailwind CSS ── クラス名でスタイリング

従来の CSS:
```css
/* styles.css */
.submit-button {
  background-color: blue;
  color: white;
  padding: 8px 16px;
  border-radius: 4px;
}
```

Tailwind CSS:
```tsx
<button className="bg-blue-500 text-white px-4 py-2 rounded">
  送信
</button>
```

**メリット:** CSS ファイルを行き来する必要がなく、コンポーネントの中でスタイルが完結する。

---

## 5. バックエンド編

### 5-1. Server Actions ── API を書かずに DB を操作する

Next.js の **Server Actions** は、クライアントから呼べるサーバーサイド関数です。

```
従来のパターン:
  ブラウザ → fetch("/api/applicants", { method: "POST" }) → API Route → DB

Server Actions のパターン:
  ブラウザ → updateApplicant(id, data)  → 直接 DB
```

#### 実際のコード例

**Server Action の定義** — `src/lib/actions/applicant.ts`

```typescript
"use server";  // ← この宣言でサーバーサイド専用になる

export async function updateApplicantField(
  applicantId: string,
  field: string,
  value: string | boolean | null
) {
  const db = getDb();
  await db
    .update(applicants)
    .set({ [field]: value, updatedAt: new Date() })
    .where(eq(applicants.id, applicantId));

  revalidatePath("/applicants");  // ← キャッシュを無効化して画面を更新
}
```

**クライアントからの呼び出し:**

```typescript
"use client";
import { updateApplicantField } from "@/lib/actions/applicant";

// ボタンクリックで直接呼べる
const handleSave = async () => {
  await updateApplicantField(applicant.id, "name", newName);
};
```

> **学習ポイント:**
> Server Actions を使うと、REST API のエンドポイント定義・fetch 呼び出し・
> レスポンスのパースといった「お決まりのコード」を省略できます。
> ただし **認証チェックを忘れがち** という落とし穴もあります（後述）。

### 5-2. API Routes ── 外部システムとの連携口

Server Actions は「ブラウザ↔サーバー」の通信に便利ですが、
**外部システム（GAS など）からの呼び出し** には従来の API Route を使います。

```
src/app/api/
├── auth/[...nextauth]/route.ts   ← 認証（NextAuth）
├── inbound/indeed/route.ts       ← Indeed 応募の受け取り（Webhook）
├── sync/
│   ├── applicants/route.ts       ← 応募者データの同期 API
│   ├── companies/route.ts        ← 企業一覧の取得 API
│   └── company-sheets/route.ts   ← シート設定の取得 API
├── companies/
│   ├── yields/csv/route.ts       ← 歩留まりCSVエクスポート
│   └── monthly-yields/csv/route.ts
└── cron/
    └── update-ages/route.ts      ← 年齢自動計算（定期実行）
```

#### Webhook の仕組み ── `/api/inbound/indeed`

```typescript
export async function POST(request: Request) {
  // 1. API キーで認証
  const apiKey = request.headers.get("x-rpo-api-key");
  if (apiKey !== env.INBOUND_API_KEY) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  // 2. リクエストボディからデータを取得
  const body = await request.json();

  // 3. 応募者を DB に保存
  await db.insert(applicants).values({
    id: crypto.randomUUID(),
    name: body.name,
    companyId: resolvedCompanyId,
    appliedAt: new Date(body.appliedAt),
    // ...
  });

  return NextResponse.json({ status: "created" });
}
```

> **学習ポイント:**
> **Webhook** とは「外部サービスがイベント発生時に自分のサーバーへ HTTP リクエストを送ってくる仕組み」です。
> Indeed → Gmail → GAS → この API という流れで、応募データが自動的に取り込まれます。

### 5-3. Server Actions と API Routes の使い分け

```
┌────────────────┬──────────────────┬──────────────────────┐
│                │ Server Actions   │ API Routes           │
├────────────────┼──────────────────┼──────────────────────┤
│ 呼び出し元     │ ブラウザ（自アプリ）│ 外部システム（GASなど）│
│ 認証           │ middleware で保護 │ API キーで認証        │
│ データ形式     │ 自動シリアライズ  │ JSON (手動パース)     │
│ 使いどころ     │ CRUD 操作全般    │ Webhook・データ連携   │
│ ファイル配置   │ lib/actions/     │ app/api/             │
└────────────────┴──────────────────┴──────────────────────┘
```

---

## 6. データベース編

### 6-1. Drizzle ORM ── TypeScript でテーブルを定義する

SQL を直接書く代わりに、TypeScript のコードでスキーマを定義します。

**スキーマ定義** — `src/db/schema.ts`

```typescript
import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core";

// 企業テーブル
export const companies = sqliteTable("companies", {
  id: text("id").primaryKey(),        // UUID
  name: text("name").notNull().unique(),
  createdAt: integer("created_at", { mode: "timestamp" }),
  updatedAt: integer("updated_at", { mode: "timestamp" }),
});

// 応募者テーブル
export const applicants = sqliteTable("applicants", {
  id: text("id").primaryKey(),
  companyId: text("company_id").references(() => companies.id),
  name: text("name"),
  phone: text("phone"),
  email: text("email"),
  appliedAt: integer("applied_at", { mode: "timestamp" }),
  // ...28 個のブール型フラグ（後述）
});
```

**クエリの書き方:**

```typescript
import { eq, like, desc } from "drizzle-orm";

// SELECT * FROM applicants WHERE company_id = ? ORDER BY applied_at DESC
const results = await db
  .select()
  .from(applicants)
  .where(eq(applicants.companyId, companyId))
  .orderBy(desc(applicants.appliedAt));
```

> **学習ポイント:**
> Drizzle の API は SQL にとても近いです。
> `select().from().where().orderBy()` と書くと、ほぼそのまま SQL に変換されます。
> まず SQL を理解し、それを Drizzle で書く練習をすると効率的です。

### 6-2. テーブル設計の解説

#### ER 図（簡略版）

```
┌──────────┐       ┌────────────────┐       ┌──────────────┐
│ companies│1─────*│  applicants    │1─────*│  callLogs    │
│──────────│       │────────────────│       │──────────────│
│ id (PK)  │       │ id (PK)        │       │ id (PK)      │
│ name     │       │ companyId (FK) │       │ applicantId  │
│ createdAt│       │ name           │       │ callerId     │
│ updatedAt│       │ phone, email   │       │ callCount    │
└──────────┘       │ appliedAt      │       │ isConnected  │
                   │ 28個のフラグ    │       │ note         │
                   │ notes          │       │ calledAt     │
                   │ assigneeName   │       └──────────────┘
                   │ updatedAt      │
                   └───────┬────────┘
                           │1
                           │
                           │*
                   ┌───────┴────────┐
                   │  interviews    │
                   │────────────────│
                   │ id (PK)        │
                   │ applicantId    │
                   │ phase          │
                   │ interviewDate  │
                   └────────────────┘
```

#### なぜ 28 個のブールフラグなのか？

応募者のステータスを `status: "面接済み"` のような 1 つの文字列ではなく、
28 個の独立したフラグで管理しています。

```typescript
// 書類選考フェーズ
isValidApplicant    // 有効な応募者か
docDeclined         // 書類辞退
docRejectedMK       // 書類不合格（MK判断）
docRejectedClient   // 書類不合格（クライアント判断）

// 一次面接フェーズ
primaryScheduled    // 日程調整済み
primaryConducted    // 面接実施済み
primaryDeclinedAfter // 一次面接後辞退
primaryRejected     // 一次不合格
primaryNoShow       // 一次面接欠席

// 二次面接・最終面接も同様のパターン...

// 内定・入社フェーズ
offered             // 内定
offerDeclined       // 内定辞退
joined              // 入社
```

**なぜ 1 つの status カラムではダメなのか？**

```
現実の採用は一方通行ではない:

  ✕ 線形モデル:  応募 → 書類通過 → 一次 → 二次 → 内定 → 入社

  ○ 現実:
    ・一次面接を通過して二次の日程調整中に辞退
    ・書類は通過したが面接に来なかった（ノーショー）
    ・一次と二次が同時並行で進む企業もある

→ 1つの status では「一次通過かつ二次辞退」のような状態を表現できない
→ 各フェーズを独立フラグにすることで、あらゆる状態の組み合わせを表現可能
```

> **学習ポイント:**
> テーブル設計は「正規化して美しく」だけでなく、 **業務の現実に合っているか** が重要です。
> このフラグ設計は正規化の観点では冗長ですが、実務では非常に使いやすい設計です。

### 6-3. マイグレーション ── テーブルの変更管理

DB のテーブル構造を変更するには **マイグレーション** を使います。

```bash
# スキーマ変更後、マイグレーションファイルを自動生成
npx drizzle-kit generate

# ローカル DB にマイグレーションを適用
npm run db:migrate:local
# → wrangler d1 migrations apply rpo-db --local が実行される
```

マイグレーションファイルは `drizzle/` フォルダに SQL として保存されます:

```sql
-- drizzle/0001_create_applicants.sql (例)
CREATE TABLE applicants (
  id TEXT PRIMARY KEY,
  company_id TEXT REFERENCES companies(id),
  name TEXT,
  ...
);
```

> **学習ポイント:**
> テーブルの変更を **手動の SQL 実行** ではなく **バージョン管理されたファイル** で行うことで、
> 「本番環境とローカル環境でテーブルが違う」という事故を防ぎます。

---

## 7. 認証・認可編

### 7-1. 認証の全体像

```
ブラウザで Google ログイン
         │
         ▼
┌──────────────────────────┐
│ Google OAuth 2.0 サーバー │
│ (Googleのサーバー)        │
└──────────┬───────────────┘
           │ 認証コード
           ▼
┌──────────────────────────┐
│ /api/auth/[...nextauth]   │
│ (NextAuth ハンドラー)      │
│                            │
│ 1. 認証コード → トークン交換│
│ 2. メール許可リスト確認     │
│ 3. JWT セッション発行       │
└──────────┬───────────────┘
           │ Cookie に JWT 保存
           ▼
       以降のリクエストは
    Cookie の JWT で認証される
```

### 7-2. NextAuth.js の設定 ── `src/auth.ts`

```typescript
export const { handlers, auth, signIn, signOut } = NextAuth({
  // Google OAuth プロバイダー
  providers: [Google],

  // JWT ベースのセッション（DB にセッションを保存しない）
  session: { strategy: "jwt" },

  callbacks: {
    // ログイン時: 許可リストに含まれるか確認
    signIn({ account, profile }) {
      if (account?.provider === "google") {
        return isLoginAllowed(profile?.email);
      }
      return false;
    },
    // JWT にユーザー ID を埋め込む
    jwt({ token, user }) {
      if (user?.id) token.userId = user.id;
      return token;
    },
  },
});
```

### 7-3. Middleware ── 認証が必要なページを保護する

```typescript
// src/middleware.ts
export default auth((req) => {
  if (!req.auth?.user) {
    // 未ログインなら /login にリダイレクト
    const loginUrl = new URL("/login", req.url);
    loginUrl.searchParams.set("callbackUrl", req.nextUrl.pathname);
    return NextResponse.redirect(loginUrl);
  }
});

// 保護対象のパス
export const config = {
  matcher: ["/applicants/:path*", "/companies/:path*", "/calls/:path*"],
};
```

### 7-4. 認可（誰が何をできるか）

```typescript
// src/lib/userAccess.ts

// ログイン許可判定
export function isLoginAllowed(email: string): boolean {
  const allowedEmails = env.LOGIN_ALLOWED_EMAILS; // "a@example.com,b@example.com"
  if (!allowedEmails) return true;  // ⚠ 未設定なら全員許可
  return allowedEmails.split(",").includes(email);
}

// 管理者判定
export function isAdminUser(email: string): boolean {
  const adminEmails = env.ADMIN_EMAILS;
  if (!adminEmails) return true;  // ⚠ 未設定なら全員管理者（要修正）
  return adminEmails.split(",").includes(email);
}
```

> **学習ポイント（セキュリティの注意）:**
> - `isAdminUser` が未設定時に `true` を返すのは **危険な設計** です
> - Server Actions 内で `await auth()` を呼んでいないものがあり、直接呼び出しで認証をバイパスできる可能性があります
> - 実務では「デフォルト拒否（Deny by Default）」の原則を守りましょう

---

## 8. 外部連携編

### 8-1. applier_trans.gs ── Indeed メール → DB 自動取り込み

この GAS は Gmail を定期的にチェックし、Indeed からの応募通知メールを解析して、
RPO アプリの API に送信します。

```
処理の流れ:

① Gmail API で Indeed からのメールを検索
   検索条件: from:indeedemail.com to:form-rpo@masterkey-inc.com
   対象: 過去 7 日間の未処理メール

② メールの件名と HTML 本文を正規表現で解析
   → 応募者名、応募職種、応募場所、企業名、メールアドレスを抽出

③ /api/inbound/indeed に POST
   ヘッダー: x-rpo-api-key で認証
   リトライ: 最大 3 回（指数バックオフ）

④ 処理結果に応じて Gmail ラベルを付与
   成功 → PROCESSED ラベル
   解析失敗 → PARSE_ERROR ラベル
   API 失敗 → API_ERROR ラベル
```

### 8-2. db_to_spreadsheet_sync.gs ── DB → 26 社分のスプレッドシートに同期

```
処理の流れ:

① /api/sync/companies から企業一覧を取得

② 企業ごとに /api/sync/applicants からデータ取得
   ページネーション: カーソルベース（200 件/ページ）

③ 各企業の Google スプレッドシートにデータを書き込み
   対象シート: 「候補者管理」タブ
   カラムマッピング: 名前、ふりがな、電話、メール、住所...

④ 新しい企業が追加された場合
   テンプレートからスプレッドシートを自動作成
```

> **学習ポイント:**
> GAS は Google Workspace と連携する **グルーコード（つなぎのプログラム）** として非常に便利です。
> 「GAS → 外部 API 呼び出し → スプレッドシート操作」のパターンは実務で頻出します。

---

## 9. インフラ編

### 9-1. Cloudflare Workers とは

```
従来のサーバー:
  東京のデータセンター 1 箇所にサーバーを設置
  → 全リクエストがそこに集中

Cloudflare Workers（エッジコンピューティング）:
  世界 300+ 箇所のデータセンターでコードが実行される
  → ユーザーに最も近い場所で処理
  → レイテンシが小さい

  さらに D1 (SQLite) も同じエッジで動くため、
  「アプリ ↔ DB」の通信がほぼゼロ
```

### 9-2. デプロイの仕組み

```bash
# ビルド + デプロイ（1コマンド）
npm run deploy
# 内部的には:
#   1. opennextjs-cloudflare build  ← Next.js を Workers 用に変換
#   2. opennextjs-cloudflare deploy ← Cloudflare にアップロード
```

**OpenNext.js の役割:**

Next.js は本来 Vercel（Next.js を作った会社）専用の最適化がされています。
OpenNext.js は Next.js を **Cloudflare Workers でも動くように変換する** アダプターです。

### 9-3. 環境変数の管理

```typescript
// src/lib/runtime-env.ts
// 3 段階のフォールバックで環境変数を取得

function getEnv(key: string): string | undefined {
  // 1. Node.js のプロセス環境変数（ローカル開発）
  if (process.env[key]) return process.env[key];

  // 2. Cloudflare Workers のバインディング（本番）
  if (globalThis.__opennext__?.env?.[key]) return ...;

  // 3. グローバルコンテキスト
  if (globalThis[key]) return ...;
}
```

> **学習ポイント:**
> ローカル開発と本番環境では環境変数の取得方法が異なります。
> この「フォールバック」パターンは、マルチ環境対応の定石です。

### 9-4. wrangler.jsonc ── Cloudflare の設定ファイル

```jsonc
{
  "name": "rpo-app",
  "main": ".open-next/worker.js",      // エントリーポイント
  "compatibility_date": "2025-12-01",
  "d1_databases": [{                    // D1 データベースのバインディング
    "binding": "DB",
    "database_name": "rpo-db",
    "database_id": "157a3bd5-...",
    "migrations_dir": "./drizzle"       // マイグレーションの場所
  }]
}
```

---

## 10. コードリーディング演習

### 演習 1: データの流れを追う（初級）

**課題:** 「応募者が Indeed で応募してから、ブラウザの画面に表示されるまで」のデータの流れを、
コードを読みながら追跡してください。

**読むべきファイル:**
1. `applier_trans.gs` — メールの解析 → API 呼び出し
2. `src/app/api/inbound/indeed/route.ts` — 応募データの受信と保存
3. `src/db/schema.ts` — 保存先テーブルの定義
4. `src/app/(dashboard)/applicants/page.tsx` — データの取得
5. `src/app/(dashboard)/applicants/ApplicantsTableClient.tsx` — 画面への表示

**確認ポイント:**
- [ ] API キーによる認証はどこで行われているか？
- [ ] 重複登録を防ぐ仕組みは何か？（ヒント: `sourceGmailMessageId`）
- [ ] 企業名がDBに存在しない場合どうなるか？

---

### 演習 2: Server Action の動きを理解する（中級）

**課題:** 応募者のステータス（例: `primaryConducted`）を画面で変更したとき、
どのようにデータが更新されるかを追ってください。

**読むべきファイル:**
1. `src/app/(dashboard)/applicants/[id]/ApplicantDetailClient.tsx` — チェックボックスの操作
2. `src/lib/actions/applicant.ts` — `updateApplicantField` の実装
3. `src/db/schema.ts` — テーブル定義

**確認ポイント:**
- [ ] `"use server"` と `"use client"` の境界はどこにあるか？
- [ ] `revalidatePath` は何をしているか？
- [ ] この Server Action にセキュリティ上の問題はないか？

---

### 演習 3: 歩留まり計算のロジックを読む（上級）

**課題:** 企業ごとの歩留まり（応募→面接→内定→入社の各段階の通過率）は
どのように計算されているかを理解してください。

**読むべきファイル:**
1. `src/lib/actions/yields.ts` — 歩留まり計算のメインロジック
2. `src/app/(dashboard)/companies/CompaniesYieldTableClient.tsx` — 表示コンポーネント
3. `src/app/api/companies/yields/csv/route.ts` — CSV エクスポート

**確認ポイント:**
- [ ] SQL の集計（`COUNT`, `SUM`）はどのように Drizzle ORM で書かれているか？
- [ ] 「通過率」はどの値をどの値で割って計算しているか？
- [ ] CSV の文字コードが UTF-8 with BOM なのはなぜか？（ヒント: Excel 互換性）

---

### 演習 4: 認証フローを追う（中級）

**課題:** `/login` ページで Google ログインボタンを押してから、
`/applicants` ページが表示されるまでの流れを追ってください。

**読むべきファイル:**
1. `src/app/login/page.tsx` — ログインページ
2. `src/app/login/google-signin-button.tsx` — Google ログインボタン
3. `src/auth.ts` — NextAuth の設定
4. `src/lib/userAccess.ts` — アクセス制御
5. `src/middleware.ts` — ルート保護

**確認ポイント:**
- [ ] OAuth 2.0 の「認可コードフロー」のどのステップが NextAuth によって自動化されているか？
- [ ] JWT セッションと DB セッションの違いは何か？
- [ ] `callbackUrl` パラメータの役割は何か？

---

## 11. 実践課題

### 課題 1: 応募者の検索機能を読み解く（★☆☆ 初級）

**目標:** 現在の検索機能がどのように実装されているかを説明する文章を書いてください。

**ヒント:**
- `ApplicantsTableClient.tsx` の検索入力欄
- Server Component での `LIKE '%keyword%'` クエリ
- 検索対象はどのカラムか？

---

### 課題 2: コール分析のヒートマップを理解する（★★☆ 中級）

**目標:** `/calls/analysis` の架電ヒートマップがどのようにデータを集計・表示しているか、
コードを読んで図解してください。

**ヒント:**
- `src/lib/actions/calls.ts` の集計ロジック
- 時間帯（2 時間ごと）× 曜日のマトリクス
- 「接続率」の計算方法

---

### 課題 3: 新しいフィールドを追加してみる（★★★ 上級）

**目標:** 応募者テーブルに「希望年収」（`desiredSalary`、整数型）を追加し、
詳細画面で編集できるようにしてください。

**手順:**
1. `src/db/schema.ts` にカラムを追加
2. `npx drizzle-kit generate` でマイグレーション生成
3. `npm run db:migrate:local` で適用
4. `ApplicantDetailClient.tsx` に入力欄を追加
5. `src/lib/actions/applicant.ts` で更新処理を確認

---

### 課題 4: セキュリティ改善をしてみる（★★★ 上級）

**目標:** Server Actions に認証チェックを追加してください。

**対象ファイル:** `src/lib/actions/applicant.ts`

**実装イメージ:**
```typescript
"use server";
import { auth } from "@/auth";

export async function updateApplicantField(...) {
  // ← ここに認証チェックを追加
  const session = await auth();
  if (!session?.user) {
    throw new Error("認証が必要です");
  }

  // 以降の処理...
}
```

---

## 12. 補足

### よくある質問

**Q: Server Components と Server Actions の違いは？**

| | Server Components | Server Actions |
|---|---|---|
| 目的 | 画面の描画（HTML 生成） | データの変更（CRUD） |
| 実行タイミング | ページアクセス時 | ボタンクリック等のアクション時 |
| 戻り値 | JSX (React 要素) | 任意の値（更新結果など） |
| 宣言方法 | デフォルト（何も書かない） | `"use server"` |

**Q: Drizzle ORM と Prisma はどう違う？**

| | Drizzle | Prisma |
|---|---|---|
| API の書き方 | SQL に近い | 独自の直感的な API |
| 型推論 | スキーマ定義から自動 | `prisma generate` で生成 |
| Workers 対応 | ネイティブ対応 | 制約あり |
| 学習コスト | SQL 知識があれば低い | SQL 知識なしでも使える |

**Q: なぜ Vercel ではなく Cloudflare を使っている？**

- Cloudflare Workers は**従量課金が安い**（月 10 万リクエストまで無料）
- D1 データベースが Workers と同じエッジで動くため**低レイテンシ**
- Workers の無料枠が業務用途に十分な範囲

---

### 用語集

| 用語 | 説明 |
|---|---|
| **SSR** | Server-Side Rendering。サーバーで HTML を生成してからブラウザに送る |
| **App Router** | Next.js 13+ のルーティング方式。ファイル配置 = URL パス |
| **Route Group** | `(dashboard)` のように括弧で囲むと URL に影響しないフォルダ |
| **Dynamic Route** | `[id]` のように角括弧で囲むと URL パラメータになる |
| **ORM** | Object-Relational Mapping。DB のテーブルをプログラムのオブジェクトとして扱う |
| **マイグレーション** | DB のテーブル構造の変更をバージョン管理する仕組み |
| **JWT** | JSON Web Token。ログイン情報を暗号化して Cookie に保存する方式 |
| **OAuth 2.0** | 外部サービス（Google 等）のアカウントで認証する仕組み |
| **Webhook** | 外部サービスがイベント発生時に自分のサーバーへ通知する仕組み |
| **エッジコンピューティング** | ユーザーに近いサーバーで処理を実行する仕組み |
| **歩留まり** | 各選考フェーズの通過率。製造業の用語が転用されている |
| **GAS** | Google Apps Script。Google Workspace を自動化するスクリプト言語 |
| **D1** | Cloudflare の SQLite 互換サーバーレスデータベース |
| **shadcn/ui** | 必要なコンポーネントだけコピーして使う UI ライブラリ |
| **Radix UI** | アクセシビリティに優れたヘッドレス（見た目なし）UIコンポーネント集 |

---

### 推薦学習リソース

**Next.js を学ぶ:**
- Next.js 公式チュートリアル: https://nextjs.org/learn

**TypeScript を学ぶ:**
- TypeScript Deep Dive (日本語): https://typescript-jp.gitbook.io/deep-dive

**SQL を学ぶ:**
- SQL の基礎を固めてから Drizzle ORM に入るのがおすすめ

**Git を学ぶ:**
- 実務では Git が必須。ブランチ運用・プルリクエストの流れを覚えましょう

---

> **最後に:**
> この教材は「完璧なコード」を紹介しているわけではありません。
> セキュリティ上の問題点や設計のトレードオフも意図的に含まれています。
> 「なぜこう書いたのか？」「自分ならどう改善するか？」を考えながら読むことで、
> 実務で通用する **批判的コードリーディング力** が身につきます。
