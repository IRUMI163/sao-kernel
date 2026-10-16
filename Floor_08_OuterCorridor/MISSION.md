# 【第8層：外界回廊】〜ファイルとOSの脈動〜

> **茅場晶彦からのシステム通達**:
> 「見事だ、剣士よ。君はメモリの荒野を抜け、ついにカーネルが管理するストレージの領域……『外界回廊』へと足を踏み入れた。
> プログラムがメモリ上に展開された一時の夢であるならば、ファイルとはディスクに刻まれる永続的な実体である。
> ディレクトリを走査し、拡張子を見分け、OSのファイルシステムと直接対話せよ。
> ここで修得する技術は、のちに最終兵器『`gear clean`』コマンドの核となる」

---

## 1. この階層で学ぶC言語とOSインターフェースの核心

これまではメモリ上のデータ（変数や動的配列）を扱ってきましたが、プログラムが終了してもデータを残すには**ファイルシステム**との連携が不可欠です。本階層では、C標準ライブラリのファイル入出力と、POSIX（Unix/Linux）標準のシステムコール／ディレクトリ操作APIを習得します。

---

### ① ファイル入出力の基本（`fopen`, `fprintf`, `fclose`）

C言語でファイルにアクセスする際は、`FILE` 構造体ポインタ（ファイルストリーム）を介して操作します。

```c
#include <stdio.h>

int main(void) {
    // 1. ファイルを開く ("w" は書き込みモード、"r" は読み込みモード、"a" は追記モード)
    FILE *fp = fopen("log.txt", "w");
    if (fp == NULL) {
        perror("Failed to open file");
        return 1;
    }

    // 2. データをファイルに書き込む
    fprintf(fp, "[SYSTEM LOG] Link Start!\n");

    // 3. ファイルを閉じる（バッファのフラッシュとリソース解放）
    fclose(fp);
    return 0;
}
```

> ⚠️ **注意**: `fopen` が失敗すると `NULL` が返ります。必ず `NULL` チェックを行う必要があります。また、開いたファイルは必ず `fclose` で閉じなければファイルリーク（リソース漏れ）の原因となります。

---

### ② ディレクトリの走査（`<dirent.h>`: `opendir`, `readdir`, `closedir`）

フォルダ（ディレクトリ）の中身を順に読み出すには、POSIXヘッダ `<dirent.h>` の関数群を使用します。

```c
#include <stdio.h>
#include <dirent.h>

void list_files(const char *dir_path) {
    DIR *dir = opendir(dir_path);
    if (dir == NULL) {
        perror("opendir failed");
        return;
    }

    struct dirent *entry;
    // readdir はディレクトリ内の要素を1つずつ返す。末尾に達すると NULL になる
    while ((entry = readdir(dir)) != NULL) {
        // entry->d_name にファイル名/フォルダ名が入っている
        printf("Found: %s\n", entry->d_name);
    }

    closedir(dir);
}
```

> 💡 **重要ルール**: `readdir` はカレントディレクトリを表す `.` や親ディレクトリを表す `..` も返します。隠しファイル（先頭が `.` のファイル）をスキップしたい場合は、`entry->d_name[0] == '.'` の条件判定で除外します。

---

### ③ ファイル情報の取得とフォルダ作成（`<sys/stat.h>`: `stat`, `mkdir`）

エントリが「ファイル」か「ディレクトリ（フォルダ）」かを判定したり、新しいディレクトリを作成するには `<sys/stat.h>` を利用します。

#### ファイル種別・属性の取得 (`stat`)
```c
#include <sys/stat.h>

struct stat st;
if (stat(full_path, &st) == 0) {
    if (S_ISDIR(st.st_mode)) {
        // ディレクトリの場合の処理
    } else if (S_ISREG(st.st_mode)) {
        // 通常ファイルの場合の処理
    }
}
```

#### ディレクトリの作成 (`mkdir`)
```c
#include <sys/stat.h>

// 第2引数の 0755 はパーミッション（所有者: 読み書き実行、グループ/その他: 読み実行）
if (mkdir("NewFolder", 0755) != 0) {
    // 既に存在する場合などはエラーとなる（errno == EEXIST）
}
```

---

### ④ ファイルの移動・リネーム（`rename`）

ファイルを別の場所や別の名前に移動するには、標準関数 `rename` を使います。

```c
#include <stdio.h>

// "dungeon_box/map.png" を "dungeon_box/Images/map.png" へ移動
if (rename("dungeon_box/map.png", "dungeon_box/Images/map.png") == 0) {
    printf("Successfully moved!\n");
} else {
    perror("rename failed");
}
```

---

## 2. 現場で飛び交う業界用語辞典

- **ファイルディスクリプタ（File Descriptor / FD）**:
  OSが管理する「開かれたファイルやソケット」を識別するための非負の整数値。0は標準入力（`stdin`）、1は標準出力（`stdout`）、2は標準エラー出力（`stderr`）に割り当てられており、`fopen` などで扱われる `FILE*` 構造体内部でも低レイヤのFDが保持されている。
- **パーミッション（Permission / アクセス権限）**:
  Unix/Linux環境において、ファイルやディレクトリに対して「誰が（所有者/グループ/その他）」「どのような操作（Read:4, Write:2, Execute:1）」を行えるかを定めた3桁の8進数（例: `0755` や `0644`）。
- **サンドボックス（Sandbox / 砂場）**:
  本番のデータやOSシステム全体に影響を与えないよう、隔離された実験用の領域（フォルダや環境）。本課題の `./dungeon_box/` は、ファイル整理機能を安心してテストするためのサンドボックス領域である。

---

## 3. ボス戦ミッション（実装仕様）

本階層の目的は、乱雑に置かれたダンジョン内のドロップアイテム（ファイル）を、拡張子に応じて自動的に適切なカテゴリフォルダ（`Images`, `Docs`, `Code`, `Archives`, `Others`）へ仕分け・移動するディレクトリクリーン関数 `clean_directory` を完成させることである。

### 対象ファイルと振り分けルール

1. **対象ディレクトリ**: `target_dir`（例: `./dungeon_box`）
2. **スキップ条件**:
   - 先頭が `.` で始まる隠しファイル（例: `.hidden_key`）およびディレクトリ参照（`.`, `..`）
   - サブディレクトリ自体（`stat` で `S_ISDIR` に該当するもの）
3. **拡張子と分類先フォルダ**:
   - `.png`, `.jpg` ➔ `Images`
   - `.pdf`, `.txt` ➔ `Docs`
   - `.c`, `.h` ➔ `Code`
   - `.zip` ➔ `Archives`
   - 上記以外の通常の拡張子／拡張子なし ➔ `Others`
4. **ディレクトリ作成とファイル移動**:
   - 該当するサブフォルダ（例: `target_dir/Images`）が存在しない場合は `mkdir(subfolder_path, 0755)` で自動作成する。
   - `dry_run == 0` の場合: ファイルを `rename()` で移動し、処理した件数をカウントする。
   - `dry_run == 1` の場合: 実際にはファイル移動（`rename`）やフォルダ作成を行わず、移動対象となるファイルの件数のみをカウントして返す。
5. **返り値**:
   - 整理（または整理予定）対象となったファイルの合計件数（`int`）を返す。

---

## 4. クリア手順と検証方法

1. **環境セットアップ**:
   ```bash
   ./setup_sandbox.sh
   ```
2. **未完成状態でのテスト実行（必ず FAIL）**:
   ```bash
   ./test.sh
   ```
3. **模範解答でのテスト検証（必ず PASS）**:
   ```bash
   ./test.sh --solution
   ```
