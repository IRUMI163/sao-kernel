# 【第6層：魂の設計図】〜構造体とデータモデリング〜

> **茅場晶彦からのシステム通達**:
> 「プレイヤー諸君、アインクラッド第6層へようこそ。
> これまで君たちは、単一の数値や文字列、配列といったバラバラのデータを扱ってきた。
> しかし、複雑なシステムを構築するには、バラバラのデータに“魂の器”を与え、意味ある一つのデータ構造として統合せねばならない。
> 構造体（`struct`）とは、プログラムにおける『魂の設計図』だ。
> 複数の属性を一つにまとめ、カプセル化し、整然としたモデルとして扱う技術を身につけよ。
> さもなくば、肥大化するコードの混沌に飲み込まれ、消滅することになるだろう」

---

## 🎴 【基本構文パターン (Pattern Example)】
迷ったらまずこの型を見よ。第6層で使う武器はこれだけだ。

```c
/* パターンA: 構造体ポインタへのアクセス（アロー演算子 ->） */
out_config->command = CMD_STAT;
out_config->dry_run = true;

/* パターンB: 構造体の安全なゼロクリア (memset) */
memset(out_config, 0, sizeof(GearConfig));

/* パターンC: バッファ上限を守る安全な文字列コピー (snprintf) */
snprintf(out_config->target_path, sizeof(out_config->target_path), "%s", "./dungeon_box");
```

---

## 🔍 【エディタに開いているコードの1行ずつ完全解体新書】
`arg_parser.c` と `config.h` に書かれているコードを1文字残らず分解・解説する。

```c
int parse_args(int argc, char *argv[], GearConfig *out_config)
```
- **`int argc, char *argv[]`**: 第2層で学んだ、ターミナルから渡されたコマンドライン引数の数と文字列配列。
- **`GearConfig *out_config`**: 解析結果を書き込むための「設定情報構造体へのポインタ（住所）」。
  - なぜポインタ渡しなのか？ 呼び出し元（`main` 関数側）にある構造体の実体を、この関数の中から直接書き換えて結果を持ち帰るため。

```c
memset(out_config, 0, sizeof(GearConfig));
```
- **`memset`**: メモリ領域を指定バイト数ぶん特定の値で塗りつぶす関数。
- ここでは構造体全体のサイズ（`sizeof(GearConfig)`）をすべて `0` で埋めることで、ゴミデータを一掃し、各フラグを初期状態（`false` や `0`）に安全にリセットしている。

```c
out_config->command = CMD_HELP;
```
- **`->`（アロー演算子）**: 「ポインタの指す先にある構造体の中のメンバ（部屋）」を指定する演算子。
  - 実体変数なら `config.command` だが、ポインタ変数の場合は必ず `out_config->command` と矢印を書く。

```c
snprintf(out_config->memo_text, sizeof(out_config->memo_text), "%s", argv[2]);
```
- **`snprintf`**: 第3層で学んだバッファオーバーフローを100%防ぐ標準関数。
- 第二引数に「配列の最大バイト数（`sizeof(...)`）」を渡すことで、もし `argv[2]` がどれほど巨大であっても絶対に配列サイズを超えて書き込まず、末尾に必ず `\0` を打ってくれる。

---

## 📖 【カタカナ英語ルビ辞典 (Ruby Words)】
プログラミングに出てくる難解な英単語を日本語でイメージせよ。

| 単語 | 読み方 | 意味・役割 |
| :--- | :--- | :--- |
| **`struct`** | ストラクト (structure) | 構造体。異なる型の変数を1つにまとめた複合データ型。 |
| **`enum`** | イーナム (enumeration) | 列挙型。コマンドや状態に分かりやすい英単語の定数名を付けたもの。 |
| **`typedef`** | タイプデフ (type definition) | 型定義。長い型名に短いエイリアス（別名）を付ける命令。 |
| **`arrow (->)`**| アロー演算子 | 矢印。ポインタが指す先の構造体のメンバにアクセスする記号。 |
| **`memset`** | メム・セット (memory set) | メモリを指定バイト数ぶん特定の値（通常は0）で塗りつぶす関数。 |
| **`snprintf`** | エス・エヌ・プリント・エフ | バッファサイズの上限を守って安全に文字列を書き込む関数。 |
| **`dry-run`** | ドライ・ラン | リハーサル。実際にファイルを動かさず、動作予告だけを出力するモード。 |

---

## 💡 【これが実際の開発でどう使えるか】
君が普段使っている `git commit -m "update"` や `docker run -d -p 80:80` などのあらゆる本格的CLIツールは、内部でどのように動いているか？
コマンドラインから渡された不規則な文字列群をそのまま振り回すのではなく、最初にすべて**「引数解析器（Arg Parser）」**に通し、今回作るような1つの設定構造体（`Config`）へと綺麗に格納する。
これにより、後続のあらゆる処理（ファイル移動やログ記録）が「構造体のフラグを見るだけ」でシンプルに実装できるようになる。これが実務で必須の**データモデリング**だ。

---

## 1. この階層で学ぶC言語の核心

### ① 構造体（`struct`）とアロー演算子（`->`）
異なるデータ型を1つのまとまりとして管理する仕組みです。

```c
typedef struct {
    GearCommand command;              // コマンド種別 (enum)
    char target_path[MAX_PATH_LEN];   // 走査対象パス
    char memo_text[MAX_MEMO_LEN];     // メモ内容
    bool dry_run;                     // リハーサル実行フラグ
    bool verbose;                     // 詳細ログフラグ
} GearConfig;
```

ポインタ経由で操作する場合、必ずアロー演算子 `->` を使用します。
```c
GearConfig config;
GearConfig *ptr = &config;

ptr->dry_run = true; // (*ptr).dry_run = true と同等
```

---

### ② 列挙型（`enum`）によるコマンド識別
マジックナンバー（`0`, `1`, `2` ...）の直接使用を避け、意味あるシンボル名で状態を管理します。

```c
typedef enum {
    CMD_NONE = 0,
    CMD_HELP,     // 1
    CMD_VERSION,  // 2
    CMD_STAT,     // 3
    CMD_MEMO,     // 4
    CMD_CLEAN     // 5
} GearCommand;
```

---

## ⚠️ 【初心者が絶対にハマる3大トラップ】

1. **トラップ1: ポインタなのにドット `.` を使ってしまう！**
   - 引数が `GearConfig *out_config`（ポインタ）であるため、`out_config.command` と書くとコンパイルエラーになります。必ず `out_config->command` とアロー演算子を使ってください。
2. **トラップ2: `memo` 引数チェックを怠りセグフォ！**
   - `./gear memo` とだけ打たれた場合、`argc` は `2` であり、`argv[2]` は存在しません（アクセスすると即座にクラッシュ）。必ず `if (argc < 3 || argv[2][0] == '\0')` で防御してください。
3. **トラップ3: `clean` のオプションループで `argv[1]` を巻き込む！**
   - `argv[1]` は `"clean"` というサブコマンド自身です。追加のオプションは `argv[2]` 以降に並ぶため、ループは必ず `for (int i = 2; i < argc; i++)` で開始してください。

---

## 🎯 【ボス戦クリア目標＆ステップ・バイ・ステップ写経ガイド】

`Floor_06_SoulBlueprint/arg_parser.c` を開き、以下の手順で完成させよ。

```c
#include "config.h"
#include <string.h>
#include <stdio.h>

int parse_args(int argc, char *argv[], GearConfig *out_config) {
    // ステップ1: 引数の防御壁チェック
    if (out_config == NULL || argc < 2) {
        return -1;
    }

    // ステップ2: 構造体のゼロクリアとデフォルト値の設定
    memset(out_config, 0, sizeof(GearConfig));
    snprintf(out_config->target_path, sizeof(out_config->target_path), "%s", "./dungeon_box");

    const char *subcmd = argv[1];

    // ステップ3: サブコマンド判定
    // -h または --help
    if (strcmp(subcmd, "-h") == 0 || strcmp(subcmd, "--help") == 0) {
        out_config->command = CMD_HELP;
        return 0;
    }

    // -v または --version
    if (strcmp(subcmd, "-v") == 0 || strcmp(subcmd, "--version") == 0) {
        out_config->command = CMD_VERSION;
        return 0;
    }

    // stat コマンド
    if (strcmp(subcmd, "stat") == 0) {
        out_config->command = CMD_STAT;
        return 0;
    }

    // memo コマンド
    if (strcmp(subcmd, "memo") == 0) {
        out_config->command = CMD_MEMO;
        if (argc < 3 || argv[2][0] == '\0') {
            return -1; // メモ文字列が無いか空文字ならエラー
        }
        snprintf(out_config->memo_text, sizeof(out_config->memo_text), "%s", argv[2]);
        return 0;
    }

    // clean コマンド
    if (strcmp(subcmd, "clean") == 0) {
        out_config->command = CMD_CLEAN;
        // argv[2] 以降のオプション引数を順次解析
        for (int i = 2; i < argc; i++) {
            if (strcmp(argv[i], "--dry-run") == 0) {
                out_config->dry_run = true;
            } else if (strcmp(argv[i], "--verbose") == 0 || strcmp(argv[i], "-v") == 0) {
                out_config->verbose = true;
            } else {
                // それ以外の引数は対象ディレクトリパスとして上書き
                snprintf(out_config->target_path, sizeof(out_config->target_path), "%s", argv[i]);
            }
        }
        return 0;
    }

    // 未知のサブコマンド
    return -1;
}
```

---

## 4. クリア手順（ターミナルで実行）

1. 模範解答でテスト（事前検証）：
   ```bash
   ./test.sh --solution
   ```
   `【判定】 CLEARED!` と表示されることを確認せよ。

2. 受講者用コード `arg_parser.c` を編集：
   ガイドに従って引数解析関数を完成させよ。

3. ボス戦（自動採点スクリプト）に挑む：
   ```bash
   ./test.sh
   ```
   全6パターンの単体テストに合格し、緑色の文字で `【判定】 CLEARED!` が出れば第6層突破だ！
