---
name: simplify
description: コードを簡潔化し、変更前後を Gate 1/Gate 2 で検証する
---

# /simplify - コード簡潔化ワークフロー

## Step 1: 対象特定（Antigravity）

- 複雑度が高い箇所を特定
- 期待する改善軸（可読性、重複削減、保守性）を定義

## Step 2: Codex コンテキスト準備（Antigravity）

`/prepare-codex-context` で対象情報を `docs/for-codex/` に集約。

## Step 3: 簡潔化方針レビュー（Codex Gate 1）

`CODEX_MODE=plan-review` で安全な簡潔化手順を確認。

## Step 4: 段階的リファクタリング（Antigravity）

- 変更を小さく分割
- 各段階でテスト実行

## Step 5: 学習レポート更新（Antigravity）

`docs/reports/{task_id}.md` に「何を簡潔化し、なぜ分割したか」を追記。
コード変更があるため、必須項目（技術選定理由、初心者チェック、参考URL）も追記する。

```bash
bash .agent/skills/codex-system/scripts/validate_report.sh docs/reports/{task_id}.md
```

## Step 6: 実装後レビュー（Codex Gate 2）

`CODEX_MODE=implementation-review` で以下を確認：

- 挙動回帰の有無
- 新たな複雑性の発生
- 見落としテスト

## Step 7: ドキュメント更新（Antigravity）

必要に応じて `docs/DESIGN.md` を更新。
