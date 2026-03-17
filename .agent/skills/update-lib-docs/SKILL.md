---
name: update-lib-docs
description: Use this skill to document library constraints, usage patterns, and gotchas in docs/libraries/
---

# Update Library Docs Skill

ライブラリの制約、使用パターン、注意点を文書化する。

## 必須前提

- `docs/for-codex/engineering-rules.md` を確認し、導入が密結合を増やさないことを確認する
- ライブラリ導入・更新でコード変更した場合は `docs/reports/{task_id}.md` を必ず追記する

## いつ使うか

- 新しいライブラリを導入したとき
- ライブラリの制約を発見したとき
- ライブラリの使い方でハマったとき
- バージョン固有の注意点があるとき

## 使わないとき

- 一般的な使い方（公式ドキュメントで十分）
- 設計判断が必要なとき（`codex-system` または `update-design` を使用）

## 出力先

`docs/libraries/{library-name}.md`

## フォーマット

```markdown
# {ライブラリ名}

バージョン: {使用バージョン}
最終更新: {日付}

## 概要
{ライブラリの目的と用途}

## インストール
~~~bash
{インストールコマンド}
~~~

## 基本的な使い方
{コード例}

## 制約・注意点

### {制約1}
{詳細と回避策}

### {制約2}
{詳細と回避策}

## プロジェクト固有の設定
{このプロジェクトでの設定内容}

## サービス境界への影響
{どのサービスで使用し、どこに依存を持ち込まないか}

## 参考リンク
- 公式ドキュメント: {URL}
- GitHub: {URL}
```
