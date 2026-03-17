# Codex 向けコンテキスト

このディレクトリは Antigravity から Codex への引き渡し層。

## 読み取りポリシー

- Codex は原則このディレクトリを先に読む。
- ここが矛盾・不足・高リスクの場合のみ、コード全体を掘る。

## 必須ファイル

- `manifest.md`
- `decision-log.md`
- `engineering-rules.md`
- `docs/reports/{task_id}.md`（学習レポート）

## 推奨ファイル

- `browser-evidence.md`
- `plan-context.md`
- `implementation-context.md`

## Gate 実行前チェック

1. `manifest.md` の必須項目（`task_id`, `generated_at`, `source_commit`, `read_order`, `coverage`, `known_gaps`, `requirements_questions_asked`, `requirements_confirmed`, `conversation_language`, `ui_language`, `readme_language`）を更新する。
2. `requirements_questions_asked` が 3 以上であることを確認する（曖昧点が残る場合は 4 以上を推奨）。
3. `requirements_confirmed` が `yes` であることを確認する。
4. `conversation_language`, `ui_language`, `readme_language` が日本語優先ポリシー（例: `ja-priority`, `ja+en`）を示すことを確認する。
5. Gate に必要なファイルだけを更新する。
6. 却下案と理由を `decision-log.md` に残す。
7. `docs/reports/{task_id}.md` に同一ファイル追記で進捗を残す。
8. コンテキストが古い場合は `ask_codex.sh` 実行前に再生成する。
9. `bash .agent/skills/codex-system/scripts/validate_report.sh docs/reports/{task_id}.md` が成功することを確認する。

## Persona 設定

- `persona_name`: ユーザー向け表示名
- `humor_level`: `off|light|on`（既定 `light`）
- `learner_mode`: `on|off`（既定 `on`）
