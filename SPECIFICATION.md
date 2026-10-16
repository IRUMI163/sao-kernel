# 『SAO: Kernel』完全設計仕様書

## 1. 全体構成とモジュール合流マップ
各フロアで学ぶ技術と作成するモジュールは、最終的に `gear/` ディレクトリの万能CLIツールへと統合される。

| 階層 | ディレクトリ名 | テーマ・C言語要素 | 最終成果物 `gear` への合流先 |
| :--- | :--- | :--- | :--- |
| 第1層 | `Floor_01_Gate` | 標準入出力 `printf`, フォーマット指定子, 型 | `gear/src/cmd_stat.c` (UI描画部) |
| 第2層 | `Floor_02_Labyrinth` | `if-else`, `for/while`, `argc/argv`, `strcmp`, 早期リターン | `gear/src/arg_parser.c` (基本分岐) |
| 第3層 | `Floor_03_SilverPrison` | 配列, 終端文字 `\0`, バッファオーバーフロー防止 (`safe_str_copy`) | `gear/src/safe_str.c`, `include/safe_str.h` |
| 第4層 | `Floor_04_DraftingRoom` | 関数分割, ヘッダファイル `.h`, インクルードガード, `Makefile` | 全体ビルド構造 |
| 第5層 | `Floor_05_Abyss` | ポインタ `&` `*`, アドレス渡し, NULLガード, ASanデバッグ | 全モジュールのポインタ操作 |
| 第6層 | `Floor_06_SoulBlueprint` | `struct`, `typedef`, `enum`, アロー演算子 `->`, `GearConfig` | `gear/include/config.h`, `src/arg_parser.c` |
| 第7層 | `Floor_07_Guillotine` | 動的メモリ確保 `malloc`, `realloc`, `free`, メモリリーク防止 | `gear/src/file_list.c`, `include/file_list.h` |
| 第8層 | `Floor_08_OuterCorridor` | ファイルI/O `fopen`, ディレクトリ走査 `opendir/readdir`, `rename` | `gear/src/cmd_memo.c`, `src/cmd_clean.c` |
| 第9層 | `Floor_09_IronWall` | `stderr`, `errno`, `perror`, 終了ステータス制御, 異常系防御 | 全コマンドのエラーハンドリング |
| 第10層 | `Floor_10_RubyPalace` | 全モジュール統合ビルド `-O2`, `uname`/`statvfs`, PATH登録 | `gear/` 完成バイナリ |

## 2. 最終成果物『gear』仕様
### コマンド体系
1. `gear stat`
   - `<sys/utsname.h>` の `uname()` と `<sys/statvfs.h>` の `statvfs(".")` を使用し、OS名・アーキテクチャ・ディスク使用率を取得してSAO風UIで表示。
2. `gear memo "<text>"`
   - `<time.h>` を用いて現在時刻付きのログを `./.gear_memo.log`（または環境変数 `GEAR_MEMO_PATH` で指定されたパス）へ追記する。
3. `gear clean [target_dir] [--dry-run] [-v]`
   - 指定ディレクトリ（デフォルトは `./dungeon_box`）内のファイルを走査し、拡張子別に `Images/` (`.png`, `.jpg`, `.gif`), `Docs/` (`.pdf`, `.md`, `.txt`), `Code/` (`.c`, `.h`, `.sh`), `Archives/` (`.zip`, `.tar`, `.gz`), `Others/` サブフォルダを作成して `rename()` で整理移動する。`--dry-run` 指定時は移動せず予定のみ出力。
4. `gear -h` / `--help` / `-v` / `--version`
   - ヘルプおよびバージョン情報の表示。
