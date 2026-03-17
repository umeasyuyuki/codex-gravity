---
name: design-tracker
description: Use this skill to record working decisions during active tasks in docs/for-codex/decision-log.md, especially after browser research or Codex Gate outputs, before promoting final decisions to docs/DESIGN.md.
---

# Design Tracker Skill

作業中の設計判断を `docs/for-codex/decision-log.md` に記録する。

## 必須前提

- `docs/for-codex/engineering-rules.md` を確認し、機能境界・契約依存・データ所有を明文化する
- コード変更がある判断を記録した場合は、同時に `docs/reports/{task_id}.md` へ追記する

## いつ使うか

- ブラウジング結果から候補を比較したとき
- Gate 1 / Gate 2 の提案を採用・却下したとき
- 最終決定前に判断履歴を残したいとき

## 使わないとき

- 最終版の設計書を更新するとき（`update-design` を使う）

## 記録フォーマット

`docs/for-codex/decision-log.md` の表に追記：

- `id`
- `decision`
- `status (adopt/reject/hold)`
- `rationale`
- `impact`
- `owner`
- `date`

加えて、マイクロサービス設計で重要な判断は `rationale` に以下を含める：

- どのサービス境界を採用したか
- どの契約（API/イベント）で連携するか
- 依存を増やさないために何を禁止したか
