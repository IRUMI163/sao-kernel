# 【第6層：魂の設計図】〜構造体とデータモデリング〜

> **茅場晶彦からのシステム通達**:
> 「プレイヤー諸君、アインクラッド第6層へようこそ。
> これまで君たちは、単一の数値や文字列、配列といったバラバラのデータを扱ってきた。
> しかし、複雑なシステムを構築するには、バラバラのデータに“魂の器”を与え、意味ある一つのデータ構造として統合せねばならない。
> 構造体（`struct`）とは、プログラムにおける『魂の設計図』だ。
> 複数の属性を一つにまとめ、カプセル化し、整然としたモデルとして扱う技術を身につけよ。
> さもなくば、肥大化するコードの混沌に飲み込まれ、消滅することになるだろう」

---

## 1. この階層で学ぶC言語の核心

これまでの階層では `int` や `char[]` といった単一の型を扱ってきましたが、現実のアプリケーション開発では「プレイヤーの名前・LV・HP・MP」や「コマンドライン引数の解析結果（コマンド種別・ターゲットパス・フラグ群）」のように、複数の異なる型のデータを1つのまとまりとして管理する必要があります。

これを実現するのが **構造体（`struct`）** と **列挙型（`enum`）** です。

---

### ① 構造体（`struct`）とメンバーアクセス

構造体は、異なるデータ型の変数を1つのグループにまとめるカスタムデータ型を作成する仕組みです。

```c
/* 構造体の定義 */
struct Player {
    char name[32];
    int level;
    int hp;
    double exp;
};

/* 構造体変数の宣言と初期化 */
struct Player p1 = {"Kirito", 10, 250, 1250.5};

/* メンバーへのアクセス（ドット演算子 .） */
printf("Player: %s (LV: %d)\n", p1.name, p1.level);
```

#### メモリ配置と構造体の本質
構造体の各メンバーはメモリ上に連続して配置されます。これにより、複数の関連データを関数の引数として渡す際も、構造体1つ（またはそのポインタ）を渡すだけで済むようになります。

---

### ② 型にエイリアスをつける `typedef`

C言語では構造体を使う際、毎回 `struct Player` と書く必要がありますが、`typedef` を使うことで簡潔な型名を定義できます。

```c
/* typedef を用いた構造体定義 */
typedef struct {
    char name[32];
    int level;
    int hp;
} Player;

/* struct キーワードなしで型として利用可能 */
Player p1;
p1.level = 15;
```

---

### ③ 列挙型（`enum`）による状態の表現

プログラム内で「コマンドの種類」や「プレイヤーの状態」を表現する際、魔法の数字（マジックナンバー: `0`, `1`, `2` ...）を直接使うとコードの読解性が著しく低下します。
`enum` を使うことで、一連の定数に名前を与えることができます。

```c
typedef enum {
    CMD_NONE = 0,
    CMD_HELP,     /* 1 */
    CMD_VERSION,  /* 2 */
    CMD_STAT,     /* 3 */
    CMD_MEMO,     /* 4 */
    CMD_CLEAN     /* 5 */
} GearCommand;

GearCommand cmd = CMD_STAT;
if (cmd == CMD_STAT) {
    /* ステータス画面の処理 */
}
```

---

### ④ 構造体ポインタとアロー演算子（`->`）

構造体を関数に引数として渡す際、値渡し（コピー）を行うとメモリ転送のオーバーヘッドが発生し、関数内での変更が呼び出し元に反映されません。
そのため、実務では **構造体のポインタ（アドレス渡し）** を使用します。

構造体ポインタ経由でメンバーにアクセスする場合は、ドット演算子 `.` ではなく **アロー演算子 `->`** を使用します。

```c
void reset_player(Player *p) {
    if (p == NULL) return;

    /* (*p).hp = 100; と同等だが、アロー演算子を用いるのが標準的 */
    p->hp = 100;
    p->level = 1;
}
```

#### アロー演算子 `->` の構文対比

| アクセス方法 | 記述形式 | 意味 |
| :--- | :--- | :--- |
| 直接アクセス | `config.dry_run = true;` | 実体（変数）のメンバーを変更 |
| 間接アクセス（展開） | `(*out_config).dry_run = true;` | ポインタを間接参照してからメンバー変更 |
| **アロー演算子** | `out_config->dry_run = true;` | ポインタ経由で直感的にメンバー変更（標準） |

---

## 2. 現場で飛び交う業界用語辞典

- **データモデリング（Data Modeling）**:
  現実世界の課題やシステム仕様を分析し、最適なデータ構造（構造体やフィールド定義）に落とし込む設計手法のこと。適切なデータモデルを定義できれば、処理ロジック（コード）は自然とシンプルかつ堅牢になる。
- **Config構造体（Configuration Structure）**:
  アプリケーション起動時の設定値やコマンドライン引数の解析結果を1つにまとめた構造体。プログラム全体に設定情報を安全かつ分かりやすく伝搬するために用いられる。
- **ドライラン（Dry-run）**:
  ファイルの削除や変更などを伴う本番処理を実行する前に、実際の変更を行わずに「どのような操作が行われるか」を事前確認・シミュレーションする実行モードのこと（例: `--dry-run` オプション）。

---

## 3. ボス戦ミッション（実装仕様）

本フロアでは、CLIツール `gear` の核となるコマンドライン引数解析エンジン `parse_args` を実装する。

### 対象ファイルとデータ構造
ヘッダファイル `gear/include/config.h` に定義されている `GearConfig` 構造体および `GearCommand` 列挙型を使用する。

```c
/* gear/include/config.h */
#define MAX_PATH_LEN 1024
#define MAX_MEMO_LEN 512

typedef enum {
    CMD_NONE = 0,
    CMD_HELP,
    CMD_VERSION,
    CMD_STAT,
    CMD_MEMO,
    CMD_CLEAN
} GearCommand;

typedef struct {
    GearCommand command;
    char target_path[MAX_PATH_LEN];
    char memo_text[MAX_MEMO_LEN];
    bool dry_run;
    bool verbose;
} GearConfig;

int parse_args(int argc, char *argv[], GearConfig *out_config);
```

---

### `parse_args` 関数詳細仕様

`parse_args(int argc, char *argv[], GearConfig *out_config)` 関数を `arg_parser.c` に実装せよ。

#### 1. 共通事前条件とデフォルト初期化
1. `out_config == NULL` または `argc < 2` の場合は、処理を行わず即座に `-1` を返せ。
2. `out_config` が指す構造体全体をゼロクリア（`memset(out_config, 0, sizeof(GearConfig))` や全メンバ初期化）せよ。
3. デフォルトの `target_path` として `"./dungeon_box"` を設定せよ（文字列コピーを行うこと）。

#### 2. サブコマンドの解析 (`argv[1]`)
`argv[1]` の文字列に応じて以下の挙動を行え：

- **`-h` または `--help` の場合**:
  - `out_config->command` に `CMD_HELP` を設定し、`0` を返せ。
- **`-v` または `--version` の場合**:
  - `out_config->command` に `CMD_VERSION` を設定し、`0` を返せ。
- **`stat` の場合**:
  - `out_config->command` に `CMD_STAT` を設定し、`0` を返せ。
- **`memo` の場合**:
  - `out_config->command` に `CMD_MEMO` を設定せよ。
  - 次の引数 `argv[2]` が存在し（`argc >= 3`）、かつ空文字列（`""`）でない場合、その内容を `out_config->memo_text` に格納（コピー）して `0` を返せ。
  - もし `argv[2]` が存在しない、または空文字列（`argv[2][0] == '\0'`）の場合は `-1` を返せ。
- **`clean` の場合**:
  - `out_config->command` に `CMD_CLEAN` を設定せよ。
  - 以降の引数 `argv[2]` から `argv[argc - 1]` を順次解析せよ（後述の `clean` オプション解析ルール参照）。解析完了後、`0` を返せ。
- **上記以外の未知のサブコマンドの場合**:
  - `-1` を返せ。

#### 3. `clean` コマンドのオプション解析ルール
`argv[1]` が `"clean"` の場合、`i = 2` から `argc - 1` までの各引数 `argv[i]` について以下のように処理せよ：

- **`"--dry-run"` の場合**: `out_config->dry_run = true;`
- **`"--verbose"` または `"-v"` の場合**: `out_config->verbose = true;`
- **それ以外の文字列（ハイフンで始まらないパス指定等）の場合**:
  - `out_config->target_path` をその文字列で上書き更新せよ。

---

### クリア手順（ターミナルで実行）

1. 未完成スケルトンでのテスト確認（失敗することを確認）:
   ```bash
   ./test.sh
   ```
2. 模範解答（.solution）でのテスト確認（成功することを確認）:
   ```bash
   ./test.sh --solution
   ```

全テストを通過（`CLEARED!`）し、第6層の魂の設計図を完成させよ！
