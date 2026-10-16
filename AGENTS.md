# AGENTS.md - Rules for AI Coding Agents (Jules)

このリポジトリはC言語＆低レイヤー学習カリキュラム『SAO: Kernel』です。
あなたが新しいフロア（`Floor_02`〜`Floor_10`）や最終成果物（`gear/`）を実装する際は、以下の規約を**絶対厳守**してください。

## 1. 教材フロアの「2重構造（Skeleton & Solution）」ルール
各フロア（`Floor_XX_Name/`）は受講者が手を動かして解くための教材です。そのため、以下のファイルを必ずセットで作成してください。
- `MISSION.md` : ストーリー、図解付きC言語解説、業界用語辞典、実装ミッション（**必ず `Floor_01_Gate/MISSION.md` の構成・文章量・熱量をGolden Sampleとして完全踏襲し、絶対に省略しないこと**）
- `main.c`（または課題の `.c` ファイル）: **受講者用の穴埋めコード（未完成状態）**。`/* TODO: ... */` コメントを残し、そのまま `./test.sh` を実行すると **FAIL（テスト失敗）** になる状態にしておくこと。
- `.solution/` ディレクトリ配下の同名ファイル（例: `.solution/main.c`）: **完全な模範解答コード**。`./test.sh --solution` を実行した際にコンパイルされ、**全テストケースがPASS（CLEARED!）** になること。
- `test.sh` : 実行権限（`chmod +x`）を付与した自動採点スクリプト。`../shared/test_helper.sh` を読み込み、通常実行時は受講者コードを、`--solution` 引数指定時は `.solution/` 内のコードをビルド＆テストすること。

## 2. 技術・コンパイル規約（Mac / WSL2 Ubuntu 完全両対応）
- **規格**: C11 (`-std=c11`) および POSIX.1-2008 準拠。Linux専用の `/proc` などは使わず、MacとUbuntuの両方で動くPOSIX標準API（`statvfs`, `uname`, `opendir`, `readdir`, `stat`, `clock_gettime` 等）のみを使用すること。
- **コンパイルフラグ**: `-std=c11 -Wall -Wextra -Werror` を必須とし、警告が1つでも出たら失敗とみなす。
- **メモリ安全性**: 第3層以降および `gear/` 本体では `-fsanitize=address` 環境下でもメモリリーク・境界外アクセスがゼロであることを保証すること。

## 3. 完了条件（Definition of Done）
PRを作成する前に、必ず作成したすべてのフロアで以下の2コマンドを実行し、両方の挙動を確認すること。
1. `./test.sh` ➔ 初期スケルトン状態のため **終了コード 1 (FAILED)** になること。
2. `./test.sh --solution` ➔ 模範解答のため **終了コード 0 (CLEARED!)** になること。
