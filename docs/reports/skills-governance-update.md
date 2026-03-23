# Learning Report: skills-governance-update

- owner: Antigravity
- started_at: 2026-02-20 00:00
- report_path: docs/reports/skills-governance-update.md
- format: markdown
- update_rule: append-only to the same file

## Goal

- スキル運用に「疎結合設計」と「コード変更時レポート必須」を組み込み、実行時に自動検証できる状態にする

## Scope

- in_scope: `.agent/skills/*`、`.agent/workflows/*`、`docs/reports/TEMPLATE.md`、`docs/for-codex/*`、検証スクリプト追加
- out_of_scope: アプリ本体機能の追加、外部サービス導入

## Timeline

### 2026-02-20 00:00 - skill-governance-update

#### What changed

- `docs/for-codex/engineering-rules.md` を追加し、疎結合設計とレポート必須ルールを共通化
- `docs/reports/TEMPLATE.md` を必須4項目に対応する形式へ更新
- 各 `SKILL.md` と主要ワークフローに、共通ルール参照とレポート更新・検証手順を追記
- `.agent/skills/codex-system/scripts/validate_report.sh` を追加し、`ask_codex.sh` から Gate 実行前に強制検証

#### Why this tech stack (for non-engineers)

- Markdown は誰でも読めて差分管理しやすく、履歴を残すのに向いているため採用
- Bash スクリプトは既存運用（ask/review）と同じ実行基盤で追加コストが低いため採用
- ルールを1ファイルに集約することで、毎回の判断ズレを減らし、学習コストを下げられるため採用

#### Must-check points for junior engineers

- 機能を足す前に「責務」「API契約」「データの正本」を先に決める
- コードを変えたら同じ `docs/reports/{task_id}.md` に追記する（新規乱立しない）
- Gate 実行前に `validate_report.sh` が通ることを確認する
- 参考URLは最低1件以上を必ず入れる

#### References (Qiita/Zenn/Official)

- [Qiita microservices tag](https://qiita.com/tags/microservices)
- [Zenn microservices topic](https://zenn.dev/topics/microservices)
- [Martin Fowler: Microservices](https://martinfowler.com/articles/microservices.html)

#### Next step

- 実運用タスクで1回このルールを適用し、見出しや検証条件の過不足を調整する

### 2026-02-20 00:10 - readme-command-list-update

#### What changed

- `README.md` に「使えるコマンド一覧」セクションを追加
- Antigravity の `/` コマンドと、ターミナル実行コマンド（ask/review/validate）を一覧化

#### Why this tech stack (for non-engineers)

- README にコマンドを集約すると、どの操作をどこで実行するか迷いにくくなるため採用
- 表形式は「コマンド」「目的」「例」を短時間で比較できるため採用

#### Must-check points for junior engineers

- `/` で始まるものは Antigravity チャットで実行する
- `bash .../scripts/*.sh` はターミナルで実行する
- Gate 実行前は `validate_report.sh` を必ず先に通す

#### References (Qiita/Zenn/Official)

- [Markdown Guide: Tables](https://www.markdownguide.org/extended-syntax/#tables)
- [OpenAI Codex CLI](https://github.com/openai/codex)
- [Zenn: Antigravity ガイド](https://zenn.dev/sora_biz/articles/antigravity-orchestra-guide)

#### Next step

- `README.en.md` へ同等セクションを同期するか検討する
