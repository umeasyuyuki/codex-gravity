---
name: update-design
description: Use this skill to promote approved architectural decisions from docs/for-codex/decision-log.md into docs/DESIGN.md, keeping final rationale, alternatives, and impact in the project-level design record.
---

# Update Design Skill

`docs/DESIGN.md` を更新し、確定した設計決定を記録する。

## 必須前提

- `docs/for-codex/engineering-rules.md` に沿って、サービス境界と依存契約を明記する
- コード変更済みタスクは `docs/reports/{task_id}.md` の追記完了を確認する

## いつ使うか

- Gate 1 / Gate 2 の結果を最終採用したとき
- アーキテクチャに影響する変更を確定したとき
- 作業中ログ (`docs/for-codex/decision-log.md`) を正式設計書に昇格するとき

## 更新手順

1. `docs/for-codex/decision-log.md` から採用済み判断を抽出
2. `docs/DESIGN.md` の履歴に追記
3. 背景・理由・代替案・影響を明記
4. 関連ログへの参照を追加
5. サービス境界、契約、データ所有者を明記して密結合を避ける

## 注意事項

- 既存内容を上書きせず追記する
- 日付を必ず含める
- 却下案も理由とともに残す
