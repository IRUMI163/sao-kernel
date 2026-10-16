# 【第8層：外界回廊】〜ファイルシステムとディレクトリ走査〜

> **茅場晶彦からのシステム通達**:
> 「プレイヤー諸君、ようこそ第8層『外界回廊』へ。
> 君たちのプログラムは、メモリという閉ざされた箱庭から脱出し、
> ついに永続化の領域——オペレーティングシステムの『ファイルシステム』へと足を踏み入れる。
>
> フォルダ（ディレクトリ）を開き、中に眠る無数のファイルたちを走査し、拡張子を見極め、適切な保管庫へと分類・再配置する。
> UNIXにおいて『すべてはファイルである』という哲学がある。
> `opendir`、`readdir`、`stat`、`rename`——OSが授けしシステム関数を自在に操り、
> 混沌とした迷宮の回廊を、整然たる美しさへと導いてみせよ」

---

## 🎴 【基本構文パターン (Pattern Example)】
迷ったらまずこの型を見よ。第8層で使う武器はこれだけだ。

```c
/* パターンA: ディレクトリ走査の黄金ルール */
DIR *dir = opendir(target_dir);
if (dir == NULL) return -1;

struct dirent *entry;
while ((entry = readdir(dir)) != NULL) {
    if (entry->d_name[0] == '.') continue; // 隠しファイルや ., .. をスキップ
    // ファイル処理
}
closedir(dir); // 必ず最後に閉じる！

/* パターンB: ファイルの末尾から拡張子を見つける (strrchr) */
const char *ext = strrchr(filename, '.'); // 最後の '.' の位置を取得

/* パターンC: フルパスを組み立ててファイル種別を判定 (stat) */
char old_path[1024];
snprintf(old_path, sizeof(old_path), "%s/%s", target_dir, entry->d_name);

struct stat st;
if (stat(old_path, &st) == 0 && S_ISDIR(st.st_mode)) {
    continue; // フォルダ自身は移動対象外としてスキップ
}
```

---

## 🔍 【エディタに開いているコードの1行ずつ完全解体新書】
`cleaner.c` に書かれているコードを1文字残らず分解・解説する。

```c
DIR *dir = opendir(target_dir);
```
- **`DIR`**: ディレクトリを読み取るためのストリーム構造体。
- **`opendir`**: フォルダを開く関数。存在しない場合は `NULL` を返す。

```c
struct dirent *entry;
while ((entry = readdir(dir)) != NULL)
```
- **`struct dirent`**: ディレクトリエントリ（ファイル1個ぶんの情報）を表す構造体。
- **`readdir`**: フォルダ内のファイルを1つずつ先頭から読み進める関数。最後のファイルを読み終わると `NULL` を返すため、`while` ループで全件走査できる。
- **`entry->d_name`**: そのファイルの名前（例: `"hero.png"` や `"notes.txt"`）。

```c
if (entry->d_name[0] == '.') continue;
```
- なぜ先頭が `.` のものをスキップするのか？
  - UNIXでは、`.` で始まるファイルは「隠しファイル（設定ファイルなど）」の規約。
  - さらに、カレント自身を示す `.` や親ディレクトリを示す `..` もこれに該当するため、1行でそれらを安全に除外できる。

```c
stat(old_path, &st)
```
- **`stat`**: ファイルのサイズ、更新日時、ファイルかディレクトリか等の属性（メタデータ）をOSから取得する関数。
- ⚠️ **超重要**: `entry->d_name`（単なるファイル名）だけを渡すと、現在の実行ディレクトリから探してしまうため失敗する。必ず `target_dir` と連結した `old_path`（完全なパス）を渡さなければならない。

```c
rename(old_path, new_path);
```
- **`rename`**: ファイルの名前を変更する関数。
- UNIXでは、「フォルダA/ファイル」から「フォルダB/ファイル」へのファイル移動は、単なる**パス名の変更（rename）**として一瞬で完了する。

---

## 📖 【カタカナ英語ルビ辞典 (Ruby Words)】
プログラミングに出てくる難解な英単語を日本語でイメージせよ。

| 単語 | 読み方 | 意味・役割 |
| :--- | :--- | :--- |
| **`opendir`** | オープン・ディア (open directory) | フォルダを開くシステム関数。 |
| **`readdir`** | リード・ディア (read directory) | フォルダ内の次のファイルを1つ読み出す関数。 |
| **`closedir`** | クローズ・ディア (close directory) | 開いたフォルダを閉じる関数。 |
| **`stat`** | スタット (status) | ファイルの属性（サイズやフォルダ種別）を調べる関数。 |
| **`dirent`** | ディア・エント (directory entry) | フォルダ内のファイル1件分のデータ構造体。 |
| **`strrchr`** | ストリング・ライト・キャラクター | 文字列の右（末尾）から指定した文字（`.`）を検索する関数。 |
| **`rename`** | リネーム | ファイル名変更（移動）を行うシステム関数。 |
| **`mkdir`** | エムケー・ディル (make directory) | 新しいフォルダを作成する関数。 |

---

## 💡 【これが実際の開発でどう使えるか】
ごちゃごちゃに散らかったデスクトップや「ダウンロード」フォルダをワンクリックで拡張子ごとに仕分けするクリーンアップツール（CLIオーガナイザー）。
また、画像処理バッチシステムやWebサーバーへのファイルアップロード処理など、現代のサーバーサイド開発で必須となる**「ファイルシステム操作」**の完全な基本形である。

---

## ⚠️ 【初心者が絶対にハマる3大トラップ】

1. **トラップ1: `stat` にファイル名単体を渡してしまう！**
   - `stat(entry->d_name, &st)` と書くと、サブフォルダ内のファイルが見つからず必ず失敗します。必ず `old_path`（`target_dir/filename`）を渡してください。
2. **トラップ2: `.` と `..` を巻き込んで無限ループ！**
   - `opendir` をすると、必ず `.`（自分）と `..`（親）という特殊エントリが返ってきます。これをスキップしないと、親フォルダを移動しようとして破綻します。
3. **トラップ3: `closedir` を忘れてリソース漏れ！**
   - ファイルやディレクトリを開いたら、最後（または途中でエラーリターンする前）に必ず `closedir` を呼び出してください。

---

## 🎯 【ボス戦クリア目標＆ステップ・バイ・ステップ写経ガイド】

`Floor_08_OuterCorridor/cleaner.c` を開き、以下の手順で実装せよ。

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

// 武器①: 拡張子から分類フォルダ名を決定するヘルパー
static const char *get_category(const char *filename) {
    const char *ext = strrchr(filename, '.');
    if (ext == NULL || ext == filename) {
        return "Others";
    }

    if (strcmp(ext, ".png") == 0 || strcmp(ext, ".jpg") == 0) {
        return "Images";
    } else if (strcmp(ext, ".pdf") == 0 || strcmp(ext, ".txt") == 0) {
        return "Docs";
    } else if (strcmp(ext, ".c") == 0 || strcmp(ext, ".h") == 0) {
        return "Code";
    } else if (strcmp(ext, ".zip") == 0) {
        return "Archives";
    } else {
        return "Others";
    }
}

// 武器②: ディレクトリ走査とクリーンアップ実行
int clean_directory(const char *target_dir, int dry_run) {
    if (target_dir == NULL) {
        return -1;
    }

    DIR *dir = opendir(target_dir);
    if (dir == NULL) {
        return -1;
    }

    struct dirent *entry;
    int moved_count = 0;

    while ((entry = readdir(dir)) != NULL) {
        // 1. 隠しファイルや ., .. をスキップ
        if (entry->d_name[0] == '.') {
            continue;
        }

        // 2. フルパスを構築
        char old_path[1024];
        snprintf(old_path, sizeof(old_path), "%s/%s", target_dir, entry->d_name);

        // 3. ファイル情報を取得し、サブディレクトリならスキップ
        struct stat st;
        if (stat(old_path, &st) != 0 || S_ISDIR(st.st_mode)) {
            continue;
        }

        // 4. カテゴリ決定と移動先パスの構築
        const char *category = get_category(entry->d_name);
        char dest_dir[1024];
        char new_path[1024];
        snprintf(dest_dir, sizeof(dest_dir), "%s/%s", target_dir, category);
        snprintf(new_path, sizeof(new_path), "%s/%s/%s", target_dir, category, entry->d_name);

        // 5. 実行モード (dry_run == 0) の場合はフォルダ作成と移動
        if (dry_run == 0) {
            mkdir(dest_dir, 0755); // フォルダが無ければ作成
            if (rename(old_path, new_path) == 0) {
                moved_count++;
            }
        } else {
            // リハーサルモード: カウントのみ
            moved_count++;
        }
    }

    closedir(dir);
    return moved_count;
}
```

---

## 4. クリア手順（ターミナルで実行）

1. 模範解答でテスト（事前検証）：
   ```bash
   ./test.sh --solution
   ```
   `【判定】 CLEARED!` と表示されることを確認せよ。

2. 受講者用コード `cleaner.c` を編集：
   ガイドに従ってディレクトリクリーン関数を完成させよ。

3. ボス戦（自動採点スクリプト）に挑む：
   ```bash
   ./test.sh
   ```
   サンドボックス内のファイル振り分けテスト（dry-run検証および実移動検証）に合格し、緑色の文字で `【判定】 CLEARED!` が出れば第8層突破だ！
