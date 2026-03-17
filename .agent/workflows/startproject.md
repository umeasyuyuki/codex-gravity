---
name: startproject
description: マルチエージェント協調でプロジェクトを開始し、日本語優先の要件深掘り質問（英語補助可）を必須化した上で2段階Codexゲートと学習レポート更新を行う
---

# /startproject - プロジェクト開始ワークフロー

## 概要

このワークフローは 8 フェーズで構成される。
Antigravity が実装を主導し、Codex は Gate 1 / Gate 2 で判断と監査を担当する。
同時に `docs/reports/{task_id}.md` を同一ファイルで追記して理解負債を防ぐ。

## Phase 0: 要件深掘り質問（日本語優先, 英語補助可, 必須）

以下の観点から最低3項目を確認し、曖昧さやリスクが残る場合は4項目以上を積極的に追加する。
回答が埋まり、要件承認が完了するまで実装に進まない：

1. 誰がどの場面で使うか（ターゲットと利用シーン）
2. V1 で絶対に必要な機能（Must）
3. 今回やらないこと（Out of Scope）
4. 成功基準（いつ完成とみなすか）
5. UI 文言の言語方針（既定は日本語、必要に応じて英語併記）
6. 技術制約（使用技術、期限、外部API、運用条件）
7. 受け入れ条件（最低限通すべきテスト・挙動）

最後に「要件確認サマリー」を提示し、ユーザーから明示承認を取る：
`この要件で実装を開始してよいですか？`

- 承認が得られない場合は再質問を継続する
- 承認前に Phase 1 以降へ進まない
- 質問数と承認有無を `docs/for-codex/manifest.md` に反映する

## Phase 1: リサーチ（Antigravity）

1. プロジェクト構造を分析
2. 既存コードパターンを把握
3. 関連ライブラリを調査
4. 結果を `docs/research/{feature}.md` に保存
5. `/update-learning-report` で要件ヒアリングと調査ログを追記

## Phase 2: 要件整理とドラフト計画（Antigravity）

- 目的、スコープ、制約、成功基準を整理
- 実装計画のドラフトを作成
- サービス境界（責務、契約、データ所有者）を定義
- `docs/for-codex/plan-context.md` に要件Q&Aサマリーを記録
- `docs/reports/{task_id}.md` に判断理由を追記

## Phase 3: Codex コンテキスト準備（Antigravity）

- `/prepare-codex-context` を実行して `docs/for-codex/` を更新
- `manifest.md` の必須キーを埋める（`requirements_questions_asked`, `requirements_confirmed`, `conversation_language`, `ui_language`, `readme_language` を含む）

## Phase 4: Gate 1 - 計画レビュー（Codex CLI）

`CODEX_MODE=plan-review` で Codex に委譲：

- 計画の妥当性
- リスク分析
- タスク分解
- 実装順序

既定 reasoning effort は `high`。
結果要約を `docs/reports/{task_id}.md` に追記。

## Phase 5: 実装とタスク実行（Antigravity）

- Gate 1 で修正した計画を実装
- テストを実行し、結果を記録
- 実装内容を `docs/reports/{task_id}.md` に追記
- 追記後に以下を実行してレポート必須項目を検証

```bash
bash .agent/skills/codex-system/scripts/validate_report.sh docs/reports/{task_id}.md
```

## Phase 6: 実装コンテキスト更新（Antigravity）

- `docs/for-codex/implementation-context.md` を更新
- `docs/for-codex/decision-log.md` に採用/却下を追記
- `manifest.md` を再更新

## Phase 7: Gate 2 - 実装レビュー（Codex CLI）

`CODEX_MODE=implementation-review` で Codex レビューを実施：

- バグ/回帰
- セキュリティ懸念
- パフォーマンス問題
- テスト戦略の不足

高リスク変更時のみ `xhigh` を使用。
最終結果を `docs/reports/{task_id}.md` に追記して完了。
