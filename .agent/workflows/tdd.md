---
name: tdd
description: Red-Green-Refactor サイクルを回しつつ Gate 1/Gate 2 でテスト戦略を監査する
---

# /tdd - テスト駆動開発ワークフロー

## Step 1: テスト戦略設計（Codex Gate 1）

`CODEX_MODE=plan-review` でテスト観点を設計。

- 正常系
- 異常系
- 境界値
- 重要なエッジケース

## Step 2: Red（Antigravity）

失敗するテストを作成し、失敗理由を確認。

## Step 3: Green（Antigravity）

テストを通す最小限の実装を行う。

## Step 4: Refactor（Antigravity）

可読性と保守性を改善し、テストが通ることを維持。

## Step 5: 学習レポート更新（Antigravity）

`docs/reports/{task_id}.md` に以下を追記：

- 失敗テストから得た知見
- 実装で意識した観点
- 境界値の扱い
- 技術スタック選定理由（非エンジニア向け）
- 駆け出しエンジニア向け必須チェック
- 参考URL（Qiita / Zenn / 公式）

追記後に以下を実行：

```bash
bash .agent/skills/codex-system/scripts/validate_report.sh docs/reports/{task_id}.md
```

## Step 6: 実装後監査（Codex Gate 2）

`CODEX_MODE=implementation-review` で以下を確認：

- 回帰リスク
- テストの不足
- 重要ケースの抜け漏れ

必要時のみ reasoning effort を `xhigh` に引き上げる。
