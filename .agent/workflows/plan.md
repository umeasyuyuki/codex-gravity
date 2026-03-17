---
name: plan
description: 要件の深掘り質問を日本語優先（英語補助可）で完了してから実装ステップに分解し、Gate 1 で計画品質を検証する
---

# /plan - 実装計画ワークフロー

## Step 1: 要件深掘り（Antigravity, 日本語優先）

- ユーザーに日本語優先で深掘り質問を行う（最低3問）
- 曖昧点や高リスクが残る場合は4問以上を積極的に追加
- 目的、スコープ、制約、成功基準、Out of Scope を明確化
- 未回答がある場合は補足質問を継続
- 要件サマリーに明示承認があるまで次ステップへ進まない

## Step 2: ドラフト計画作成（Antigravity）

- 実装ステップ
- 依存関係
- 検証基準
- マイクロサービス境界（責務、契約、データ所有）を明記
- 他機能との密結合を避ける実装方針を明記

## Step 3: 学習レポート更新（Antigravity）

`/update-learning-report` で `docs/reports/{task_id}.md` に要件整理と計画意図を追記。
コード変更予定がある場合、必須項目4点の見出しを先に作成しておく。

## Step 4: Codex コンテキスト準備（Antigravity）

`/prepare-codex-context` で `docs/for-codex/` を更新。

## Step 5: Gate 1 計画レビュー（Codex CLI）

```bash
CODEX_MODE=plan-review \
bash .agent/skills/codex-system/scripts/ask_codex.sh \
  --mode design \
  --question "Review and decompose the implementation plan from docs/for-codex."
```

## Step 6: 計画確定（Antigravity）

- Codex提案を反映
- ユーザー承認を取得
- 学習レポートに確定内容を追記

## Step 7: 設計ドキュメント更新（Antigravity）

確定計画を `docs/DESIGN.md` に記録。
