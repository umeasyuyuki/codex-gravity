---
name: init
description: 新規プロジェクトにOrchestra環境をセットアップする
---

# /init - Orchestra環境初期化ワークフロー

## 概要

このワークフローは一度だけ実行し、必要なディレクトリとファイルを作成する。

## Step 1: ディレクトリ構造の確認

以下のディレクトリが存在するか確認：

```
.agent/
├── workflows/
├── skills/
│   ├── codex-system/scripts/
│   ├── design-tracker/
│   ├── research/
│   ├── update-design/
│   └── update-lib-docs/
└── rules/

.codex/

docs/
├── for-codex/
├── reports/
├── research/
├── libraries/
└── checkpoints/

logs/
└── codex-responses/
```

## Step 2: 不足ディレクトリの作成

存在しないディレクトリを作成。

## Step 3: 設定ファイルの確認

以下のファイルが存在するか確認：

- `.agent/workflows/*.md` (8ファイル)
- `.agent/skills/*/SKILL.md` (5スキル)
- `.agent/rules/*.md` (9ファイル)
- `.codex/AGENTS.md`
- `docs/DESIGN.md`
- `docs/for-codex/manifest.md`
- `docs/reports/TEMPLATE.md`

## Step 4: 不足ファイルの作成

存在しないファイルをテンプレートから作成。

## Step 5: macOS 実行環境の確認

`scripts/ask_codex.sh`、`scripts/review.sh`、`scripts/validate_report.sh` が存在し、実行権限を持つか確認。

```bash
which node
which codex
bash .agent/skills/codex-system/scripts/ask_codex.sh --help
```

## Step 6: オプション検証環境の確認

Skill検証を使う場合は依存を満たす：

```bash
python3 -c "import yaml"
```

失敗する場合は `PyYAML` を導入してから `quick_validate.py` を使う。

## Step 7: 完了報告

セットアップ完了を報告し、次のステップを案内。
