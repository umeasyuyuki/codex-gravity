---
name: update-learning-report
description: タスク進行中の学習レポートを docs/reports/{task_id}.md に追記して理解負債を防ぐ
---

# /update-learning-report - 学習レポート更新ワークフロー

## 目的

駆け出しエンジニアでも追える形で、同一レポートに進捗と判断理由を蓄積する。

## Step 1: 対象レポートを決定

- `task_id` を決定
- レポートパスを `docs/reports/{task_id}.md` に固定

## Step 2: レポート初期化（初回のみ）

- ファイルが存在しなければ `docs/reports/TEMPLATE.md` をコピーして作成
- 作成後も Markdown 形式を維持する

## Step 3: マイルストーンごとに追記

以下のタイミングで同一ファイルへ追記する：

1. 要件深掘り質問と要件承認の完了時
2. Gate 1 完了時
3. 実装完了時
4. Gate 2 完了時

コード変更が発生した場合（初回実装、機能追加、バグ修正、リファクタ）は必ず追記する。

## Step 4: 追記フォーマット

各追記ブロックには以下を含める：

- `日時`
- `フェーズ`
- `何を実装・修正したか`
- `なぜその技術スタックにしたか（非エンジニア向け）`
- `駆け出しエンジニアが必ず確認すべきポイント`
- `参考URL（Qiita / Zenn / 公式）`
- `次にやること`

## Step 5: レポート検証

Gate 実行前に検証スクリプトを実行する：

```bash
bash .agent/skills/codex-system/scripts/validate_report.sh docs/reports/{task_id}.md
```

## Step 6: manifest 連携

`docs/for-codex/manifest.md` の `report_path` を更新して同期を保つ。
