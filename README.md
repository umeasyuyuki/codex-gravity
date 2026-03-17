# 🎼 Antigravity Orchestra

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-macOS%20(Apple%20Silicon)-blue.svg)](#前提条件)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/Sora-bluesky/antigravity-orchestra/issues)

**🌐 Language: 日本語 | [English](README.en.md)**

---

**Antigravity Orchestra** は、[Google Antigravity](https://antigravity.google)（Gemini 3 Pro）と [OpenAI Codex CLI](https://github.com/openai/codex) を協調させるマルチエージェント開発テンプレートです。

[Claude Code Orchestra](https://github.com/DeL-TaiseiOzaki/claude-code-orchestra)（@mkj / 松尾研究所）にインスパイアされています。

---

## ✨ これは何？

```
┌─────────────────────────────────────────────────────────────┐
│                      ユーザー                               │
│                         │                                  │
│                         ▼                                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │    Google Antigravity (Orchestrator + Researcher)     │  │
│  │    → Gemini 3 Pro / 大規模コンテキスト                │  │
│  │    → ユーザー対話・リサーチ・実装を担当               │  │
│  │                                                       │  │
│  │        ┌─────────────────────────────────────────┐    │  │
│  │        │   Codex CLI (Skills の scripts/ 経由)   │    │  │
│  │        │   → 設計・デバッグ・レビューを担当      │    │  │
│  │        └─────────────────────────────────────────┘    │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

**インターフェースは Antigravity だけ。** ユーザーは Antigravity とだけ対話し、必要に応じて Antigravity が Codex に相談します。

---

## 🗣️ 言語ポリシー

- UI文言は日本語を既定とし、必要に応じて英語併記を許可する
- `README.md` を正本とし、`README.en.md` は派生ドキュメントとして柔軟に更新する
- `/startproject` と `/plan` の要件深掘り会話は日本語優先で実施する（必要なら英語補助可）

---

## 🎯 こんな人におすすめ

- Antigravity を使っているが、設計やレビューの品質を上げたい
- 複数の AI を使い分けるのが面倒
- Google と OpenAI、2社の AI の視点でチェックしたい

---

## 🎭 役割分担

| 役割 | 担当 | タスク |
|------|------|--------|
| **Orchestrator** | Antigravity | ユーザー対話、タスク管理、ワークフロー制御 |
| **Researcher** | Antigravity | ライブラリ調査、ドキュメント検索（大規模コンテキスト活用） |
| **Builder** | Antigravity | Codex の設計に基づくコード実装、ファイル編集 |
| **Designer** | Codex CLI | アーキテクチャ設計、実装計画、トレードオフ分析 |
| **Debugger** | Codex CLI | 根本原因分析、複雑なバグ調査 |
| **Auditor** | Codex CLI | コードレビュー、品質チェック、TDD設計 |

---

## 🧭 初見ユーザー向け 30秒理解

この Agent は次の流れで動きます。

1. あなたは Antigravity にだけ話しかける
2. Antigravity が要件整理・調査・実装を進める
3. 設計判断やレビューが必要な地点だけ Codex に委譲する
4. 結果は `docs/` と `logs/` に保存され、再開可能な状態が残る

---

## 🧠 Agent機能と役割（網羅版）

| 機能 | 主担当 | いつ使うか | 主入力 | 主出力 |
|------|--------|-----------|--------|--------|
| 要件深掘り | Antigravity | 実装前に要件が曖昧 | ユーザー会話 | `docs/for-codex/manifest.md`（質問数・承認状態） |
| 技術リサーチ | Antigravity | ライブラリ/APIの比較検討 | 公式Docs/GitHub/既存コード | `docs/research/{topic}.md` |
| Codex向け正規化 | Antigravity | Gate実行前 | 調査メモ、実装差分、判断履歴 | `docs/for-codex/*.md` |
| Gate 1 計画レビュー | Codex CLI | 実装計画の妥当性確認 | `docs/for-codex/plan-context.md` | `logs/codex-responses/plan-review-*.md` |
| 実装・編集 | Antigravity | Gate 1 後 | Codex提案、既存コード | 変更ファイル + テスト結果 |
| Gate 2 実装監査 | Codex CLI | 実装後の回帰/リスク検知 | `docs/for-codex/implementation-context.md` | `logs/codex-responses/implementation-review-*.md` |
| 作業中判断の記録 | Antigravity (`design-tracker`) | 採用/却下判断が発生 | Gate結果、比較結果 | `docs/for-codex/decision-log.md` |
| 最終設計への昇格 | Antigravity (`update-design`) | 設計確定時 | `decision-log.md` | `docs/DESIGN.md` |
| ライブラリ制約の蓄積 | Antigravity (`update-lib-docs`) | 導入時・ハマり時 | 調査結果、実装知見 | `docs/libraries/{library}.md` |
| 学習レポート追記 | Antigravity (`update-learning-report`) | 要件後/Gate後/実装後 | 進捗・理由・結果 | `docs/reports/{task_id}.md` |
| セッション再開準備 | Antigravity (`checkpoint`) | 作業中断前 | 現在状態 | `docs/checkpoints/*.md` |

---

## 🔒 オーケストレーションを壊さない不変条件

このテンプレートは以下を固定契約として運用します。

1. ユーザーI/Fは常に Antigravity 側（Codex直接対話にしない）
2. Codex の実行は `--sandbox read-only` 固定（編集させない）
3. `CODEX_MODE` は `plan-review` / `implementation-review` / `ad-hoc` のみ
4. Gate 実行前に `docs/for-codex/manifest.md` の必須キーを満たす
5. 実装とファイル編集は常に Antigravity が担当
6. 重要判断は `decision-log.md` に残し、確定後に `docs/DESIGN.md` に昇格
7. 新規実装・機能追加は `docs/for-codex/engineering-rules.md` の疎結合ルールを満たす
8. コード変更時は `docs/reports/{task_id}.md` を必ず更新し、同一ファイルに追記する
9. Gate 実行前に `bash .agent/skills/codex-system/scripts/validate_report.sh docs/reports/{task_id}.md` を通す

---

## 🌐 思考と言語の運用

- 内部推論: 英語ベース（設計・分析の精度優先）
- ユーザー向け出力: 日本語ベース（必要時のみ英語併記）
- Codex問い合わせ文: 英語中心で構成
- README/UI/要件深掘り会話: 日本語優先

このため、**精度（英語推論）と運用性（日本語コミュニケーション）**を両立できます。

---

## 📋 前提条件

| 必要なもの | 確認方法 | 備考 |
|-----------|----------|------|
| Google Antigravity | Antigravity が起動できる | [公式サイト](https://antigravity.google) |
| macOS (Apple Silicon) | `uname -m` が `arm64` | 推奨: macOS 14+ |
| Homebrew | `brew --version` | [brew.sh](https://brew.sh) |
| Node.js | `which node` が `/opt/homebrew/bin/node` | [nodejs.org](https://nodejs.org) |
| Codex CLI | `which codex` が `/opt/homebrew/bin/codex` | `npm i -g @openai/codex` |
| ChatGPT Plus/Pro | OpenAI サブスクリプション | $20/月〜（OAuth認証） |

---

## 🚀 クイックスタート

完全版手順は `docs/MACOS_SETUP_COMPLETE.md` を参照してください。

### Step 1: テンプレートの取得

macOS のターミナル（zsh）で実行：

```bash
# プロジェクトフォルダに移動
cd /Users/asyuyukiume/Projects

# テンプレートをクローン
git clone https://github.com/Sora-bluesky/antigravity-orchestra.git my-project

# プロジェクトに移動
cd my-project
```

### Step 2: 実行環境の確認

Node.js と Codex のパスを確認：

```bash
which node    # /opt/homebrew/bin/node
which codex   # /opt/homebrew/bin/codex
```

`codex-system` スクリプトはこの環境に合わせて設定済みです。
必要なら環境変数で上書きできます：

```bash
NODE_PATH="$(which node)" \
CODEX_PATH="$(which codex)" \
bash .agent/skills/codex-system/scripts/ask_codex.sh --mode analyze --question "Environment check"
```

通常利用では設定変更は不要です。

### Step 3: Antigravity でプロジェクトを開く

1. **Antigravity を起動**
2. **File → Open Folder** をクリック（または `Cmd+K`, `Cmd+O`）
3. 以下のフォルダに移動：
   - `/Users/asyuyukiume/Projects/my-project`
4. **「フォルダーの選択」** をクリック

### Step 4: 動作確認

Antigravity のチャットで入力：

```
/startproject Hello World
```

Antigravity が以下を自動的に実行すれば成功です：

1. リポジトリ構造を分析
2. 日本語優先で要件を深掘り質問し（最低3問、必要なら4問以上）、要件サマリーの承認を取得
3. `docs/for-codex/` を生成
4. Codex Gate 1 で計画レビューを実施
5. タスクリストを作成
6. 実装後は Codex Gate 2 を実施

---

## 📁 ディレクトリ構成

```
my-project/
├── .agent/
│   ├── workflows/        # 8 ワークフロー
│   │   ├── startproject.md   # メインワークフロー（8フェーズ）
│   │   ├── plan.md           # 実装計画
│   │   ├── tdd.md            # テスト駆動開発
│   │   ├── simplify.md       # リファクタリング
│   │   ├── checkpoint.md     # セッション永続化
│   │   ├── prepare-codex-context.md # Codex用コンテキスト生成
│   │   ├── update-learning-report.md # 学習レポート追記
│   │   └── init.md           # 初期化
│   │
│   ├── skills/           # 5 スキル
│   │   ├── codex-system/     # Codex CLI 連携
│   │   │   ├── SKILL.md
│   │   │   └── scripts/
│   │   │       ├── ask_codex.sh
│   │   │       ├── review.sh
│   │   │       └── validate_report.sh
│   │   ├── design-tracker/
│   │   ├── research/
│   │   ├── update-design/
│   │   └── update-lib-docs/
│   │
│   └── rules/            # 9 ルール
│       ├── delegation-triggers.md  # 自動振り分け（Hooks代替）
│       ├── role-boundaries.md      # 役割境界
│       ├── language.md
│       ├── persona-style.md        # 円堂侑進トーン制御
│       ├── codex-delegation.md
│       ├── coding-principles.md
│       ├── dev-environment.md
│       ├── security.md
│       └── testing.md
│
├── .codex/               # Codex CLI 設定
│   └── AGENTS.md
│
├── docs/                 # 知識ベース
│   ├── DESIGN.md             # 設計決定記録
│   ├── for-codex/            # Codex委譲用の構造化コンテキスト
│   │   └── engineering-rules.md # 疎結合設計 + 変更レポート必須ルール
│   ├── reports/              # 初学者向け学習レポート
│   ├── checkpoints/          # セッション再開用チェックポイント
│   ├── research/             # リサーチ結果
│   └── libraries/            # ライブラリ制約
│
└── logs/
    └── codex-responses/      # Codex 相談ログ
```

---

## 📖 Workflows の詳細

### /startproject - メインワークフロー（8フェーズ）

```
┌─────────────────────────────────────────────────────────────────┐
│  Phase 0: Antigravity (Requirements Deep Dive / JA)             │
│  → 日本語優先で要件深掘り質問（最低3問、必要なら4問以上）        │
│  → 要件サマリーをユーザー承認                                    │
├─────────────────────────────────────────────────────────────────┤
│  Phase 1: Antigravity (Research)                                │
│  → リポジトリ分析・ライブラリ調査                               │
│  → Output: docs/research/{feature}.md                           │
├─────────────────────────────────────────────────────────────────┤
│  Phase 2: Antigravity (Requirements Draft Plan)                 │
│  → 承認済み要件を計画ドラフトに変換                              │
├─────────────────────────────────────────────────────────────────┤
│  Phase 3: Antigravity (Prepare Codex Context)                   │
│  → docs/for-codex/ に構造化コンテキストを生成                   │
├─────────────────────────────────────────────────────────────────┤
│  Phase 4: Codex CLI (Gate 1: Plan Review)                       │
│  → 計画レビュー・リスク分析・タスク分解                          │
├─────────────────────────────────────────────────────────────────┤
│  Phase 5: Antigravity (Task Creation / Implementation)          │
│  → 全入力を統合                                                 │
│  → タスクリスト確定と実装                                       │
├─────────────────────────────────────────────────────────────────┤
│  Phase 6: Antigravity (Update docs/for-codex)                   │
│  → 実装差分・テスト結果・判断履歴を更新                          │
├─────────────────────────────────────────────────────────────────┤
│  Phase 7: Codex CLI (Gate 2: Implementation Review)             │
│  → 実装後レビュー・テスト戦略監査                                │
└─────────────────────────────────────────────────────────────────┘
```

### /plan - 実装計画

Codex の支援で詳細な実装計画を作成します。

```
/plan ユーザー認証機能の追加
```

### /tdd - テスト駆動開発

Codex がテストケースを設計し、Antigravity が Red-Green-Refactor サイクルを実行します。

```
/tdd ログイン機能
```

### /simplify - リファクタリング

コードを簡潔化し、可読性を向上させます。

```
/simplify src/auth/login.py
```

### /checkpoint - セッション永続化

セッション状態を保存して後で再開できます。

```
/checkpoint          # 基本: 履歴ログ
/checkpoint --full   # 完全: git履歴・ファイル変更含む
```

### /prepare-codex-context - Codex連携コンテキスト生成

Antigravity の成果物を `docs/for-codex/` に正規化し、Gate 1 / Gate 2 に渡します。

```
/prepare-codex-context
```

### /update-learning-report - 学習レポート追記

同一ファイル `docs/reports/{task_id}.md` に進捗と判断理由を追記します。

コード変更（初回実装、機能追加、バグ修正、リファクタ）の場合は、必ず以下を含めます。

- 何を実装・修正したか
- なぜその技術スタックにしたか（非エンジニア向け）
- 駆け出しエンジニアが必ず確認すべきポイント
- 参考URL（Qiita / Zenn / 公式）

Gate 前の検証コマンド：

```bash
bash .agent/skills/codex-system/scripts/validate_report.sh docs/reports/{task_id}.md
```

```
/update-learning-report
```

---

## ⌨️ 使えるコマンド一覧

### Antigravity チャットコマンド（`/`コマンド）

| コマンド | 目的 | 例 |
|---------|------|----|
| `/startproject` | プロジェクト開始の8フェーズ実行 | `/startproject ユーザー認証機能` |
| `/plan` | 実装計画の作成と Gate 1 連携 | `/plan 決済機能の追加` |
| `/tdd` | TDD サイクルで実装を進める | `/tdd ログイン機能` |
| `/simplify` | コード簡潔化・段階的リファクタ | `/simplify src/auth/login.py` |
| `/checkpoint` | 現在状態を保存して再開可能にする | `/checkpoint --full` |
| `/prepare-codex-context` | Gate 用に `docs/for-codex/` を更新 | `/prepare-codex-context` |
| `/update-learning-report` | 学習レポートを同一ファイルに追記 | `/update-learning-report` |
| `/init` | テンプレート環境の初期化確認 | `/init` |

### シェルコマンド（ターミナル実行）

| コマンド | 目的 |
|---------|------|
| `bash .agent/skills/codex-system/scripts/ask_codex.sh --mode design --question "Review this plan"` | Codex に単発相談する |
| `CODEX_MODE=implementation-review bash .agent/skills/codex-system/scripts/review.sh` | Gate 2 の実装監査を実行する |
| `bash .agent/skills/codex-system/scripts/validate_report.sh docs/reports/{task_id}.md` | Gate 前にレポート必須項目を検証する |

---

## 🛠️ Skills の詳細

### codex-system - Codex CLI 連携

設計・デバッグ・レビューを Codex に委譲するための核心スキル。

**Gate 実行前の必須チェック：**

1. `docs/for-codex/engineering-rules.md` を確認
2. `docs/reports/{task_id}.md` を更新（変更がある場合）
3. `bash .agent/skills/codex-system/scripts/validate_report.sh docs/reports/{task_id}.md` を実行

**トリガーキーワード：**

| 分類 | キーワード |
|------|-----------|
| 設計系 | 「設計」「アーキテクチャ」「どう作る」「design」「architecture」 |
| デバッグ系 | 「なぜ動かない」「エラー」「バグ」「debug」「error」 |
| レビュー系 | 「レビュー」「チェック」「確認」「review」「check」 |

**使わないとき：**

- 単純なファイル編集
- リサーチ・調査（Antigravity 自身が行う）
- ユーザーとの会話

### その他のスキル

| スキル | 用途 |
|--------|------|
| design-tracker | 作業中の判断を docs/for-codex/decision-log.md に記録 |
| research | ライブラリ調査とドキュメント作成 |
| update-design | 確定判断を docs/DESIGN.md に昇格 |
| update-lib-docs | ライブラリ制約の文書化 |

---

## 📏 Rules の詳細

### delegation-triggers.md（最重要）

Claude Code Orchestra の 6つの Hooks を Rules で代替します。

**判断フロー（意図ベース + キーワード補助）：**

```
ユーザー入力を受け取る
    │
    ▼
【チェック1】設計判断・計画分解が必要か？
    → Yes: /prepare-codex-context → Gate 1 (plan-review)
    │
    ▼
【チェック2】TDDが必要か？
    → Yes: /tdd を提案（Antigravityは直接テスト設計しない）
    │
    ▼
【チェック3】デバッグが必要か？
    → Yes: ad-hoc で codex-system スキルを使用
    │
    ▼
【チェック4】実装が完了したか？
    → Yes: /prepare-codex-context → Gate 2 (implementation-review)
    │
    ▼
Antigravity が直接実行（リサーチ、ファイル編集等）
```

### role-boundaries.md（役割境界）

| Antigravity が行うこと | Codex に委譲すること |
|----------------------|---------------------|
| ユーザー対話 | テスト設計（TDD） |
| ライブラリ調査 | アーキテクチャ設計 |
| ファイル編集 | トレードオフ分析 |
| コード実装 | 根本原因分析 |
| | コードレビュー |

**Quick Rule: 「これ、設計の判断が必要？」と思ったら → Codex に委譲**

### その他のルール

| ルール | 内容 |
|--------|------|
| language.md | 思考は英語、日本語優先（UI/README/会話）で必要時に英語併記 |
| persona-style.md | 円堂侑進の明るさを保ちつつ品質を守るトーン制御 |
| codex-delegation.md | Codex への委譲ルール詳細 |
| coding-principles.md | シンプルさ、単一責任、早期リターン、疎結合設計、変更レポート必須 |
| dev-environment.md | 開発環境設定（uv, ruff, pytest等） |
| security.md | 機密情報管理、入力検証 |
| testing.md | TDD、AAA パターン、カバレッジ目標 |

---

## 💬 基本的な使い方

### 例1: 新機能の開発

```
/startproject ユーザー認証機能
```

Antigravity が自動的に8フェーズを実行します。

### 例2: 設計相談

```
この機能、どう設計すべき？
```

Antigravity が「設計」キーワードを検出し、Codex に委譲します。

### 例3: デバッグ

```
このエラーの原因がわからない
```

Antigravity が根本原因分析を Codex に委譲します。

### 例4: テスト駆動開発

```
/tdd ログイン機能
```

Codex がテストケースを設計し、Antigravity が実装します。

---

## ❓ よくある質問

<details>
<summary><strong>Q: Codex CLI なしでも使えますか？</strong></summary>

はい、ただし設計レビューやデバッグ機能が使えなくなります。Antigravity がすべてを直接処理するため、複雑なプロジェクトでは品質が下がる可能性があります。

</details>

<details>
<summary><strong>Q: なぜ shell スクリプト経由で Codex を呼ぶのですか？</strong></summary>

macOS では Antigravity と Codex CLI が同一環境で動くため、`bash` スクリプトで直接呼び出す構成にしています。WSL ブリッジは不要です。

</details>

<details>
<summary><strong>Q: Node.js を再インストールしたらパスはどうなりますか？</strong></summary>

1. `which node` と `which codex` を実行
2. 必要なら `NODE_PATH` / `CODEX_PATH` を環境変数で上書き
3. `ask_codex.sh` / `review.sh` を再実行

</details>

<details>
<summary><strong>Q: ワークフローをカスタマイズできますか？</strong></summary>

はい！`.agent/workflows/` 内のファイルを編集してください。各ワークフローは frontmatter（name, description）とステップバイステップの手順を含む Markdown ファイルです。

</details>

<details>
<summary><strong>Q: ChatGPT Plus と Pro、どちらが必要ですか？</strong></summary>

Plus（$20/月）で十分使えます。Pro（$200/月）はより多くの使用量が必要な場合に検討してください。

</details>

---

## 🔧 トラブルシューティング

| 問題 | 解決策 |
|------|--------|
| Codex スキルが起動しない | 明示的に「Codex に相談して」と依頼、またはキーワード（設計、デバッグ、レビュー）を使用 |
| パスが見つからないエラー | `which node` と `which codex` を再確認し、必要なら `NODE_PATH` / `CODEX_PATH` を指定 |
| `permission denied` | `chmod +x .agent/skills/codex-system/scripts/*.sh` を実行 |
| レポート検証で失敗する | `docs/reports/{task_id}.md` に必須見出し4つと参考URLを追加して再実行 |
| 役割境界が守られない | 明示的に「TDDはCodexに委譲して」と指示 |

---

## ⚠️ 注意事項

- **Google Antigravity はパブリックプレビュー版です。** 機能や動作が変更される可能性があります。
- **Codex CLI は ChatGPT サブスクリプションが必要です。** OAuth 認証でサインインします。
- 最新情報は[公式サイト](https://antigravity.google)を確認してください。

---

## 🤝 フィードバック

バグ報告や改善提案は [Issue](https://github.com/Sora-bluesky/antigravity-orchestra/issues) でお願いします。

---

## 🔗 関連リンク

### 参考資料

| 資料 | 著者 | 内容 |
|------|------|------|
| [Claude Code Orchestra](https://zenn.dev/mkj/articles/claude-code-orchestra_20260120) | @mkj（松尾研究所） | マルチエージェント協調の概念 |
| [GitHub: claude-code-orchestra](https://github.com/DeL-TaiseiOzaki/claude-code-orchestra) | DeL-TaiseiOzaki | 実装例 |

### ツール

- [Google Antigravity](https://antigravity.google)
- [OpenAI Codex CLI](https://github.com/openai/codex)

### 関連記事

- [Antigravity ガイド](https://zenn.dev/sora_biz/articles/antigravity-orchestra-guide)
- [詳しい使い方（Zenn記事）](https://zenn.dev/sora_biz/articles/antigravity-orchestra-guide)
- [macOS版 完全セットアップ手順](docs/MACOS_SETUP_COMPLETE.md)

---

## 📜 ライセンス

MIT License - 詳細は [LICENSE](LICENSE) を参照してください。

---

## 🙏 謝辞

このプロジェクトは **Claude Code Orchestra**（[@mkj](https://zenn.dev/mkj) / 松尾研究所）にインスパイアされています。マルチエージェント協調のオリジナルアーキテクチャとコンセプトを、Google Antigravity ユーザー向けに移植しました。

---

📅 **最終更新**: 2026年2月20日
