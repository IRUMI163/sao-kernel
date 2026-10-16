# 【第9層：堅牢なる城壁】〜標準入出力とエラーハンドリング〜

> **茅場晶彦からのシステム通達**:
> 「プレイヤー諸君、ようこそ第9層『堅牢なる城壁』へ。
> いよいよ最上層（第10層）への扉が目前に迫った。
> だが、ただ動くだけの脆いプログラムでは、本物のシステム管理者の資格はない。
> 予期せぬ引数の欠落、存在しないファイル、拒絶された権限——あらゆる災厄を予見し、
> 完璧に受け流す強固なエラー処理（エラーハンドリング）を備えてこそ、真の堅牢性を獲得できる。
>
> 正常な結果を流す『標準出力（`stdout`）』と、警告を告げる『標準エラー出力（`stderr`）』。
> そしてOSが発する悲鳴を解読する『`errno`』と『`strerror`』。
> 失敗をも味方につける堅牢なる城壁を築き上げ、最終関門へと進め」

---

## 🎴 【基本構文パターン (Pattern Example)】
迷ったらまずこの型を見よ。第9層で使う武器はこれだけだ。

```c
/* パターンA: 標準エラー出力 (stderr) へのメッセージ出力 */
fprintf(stderr, "[USAGE ERROR] File path required\n");
return 1; // 異常終了コードを返す

/* パターンB: OSのエラー理由を人間が読める文字にする (errno & strerror) */
FILE *fp = fopen(filepath, "r");
if (fp == NULL) {
    fprintf(stderr, "[IO ERROR] %s\n", strerror(errno));
    return 2;
}

/* パターンC: ファイルを1文字ずつ読んで改行数を数える (EOF判定) */
long lines = 0;
int ch; // EOF (-1) を正しく受け取るため必ず int 型にする！
while ((ch = fgetc(fp)) != EOF) {
    if (ch == '\n') lines++;
}
fclose(fp); // 必ず閉じる！
```

---

## 🔍 【エディタに開いているコードの1行ずつ完全解体新書】
`main.c` に書かれているコードを1文字残らず分解・解説する。

```c
fprintf(stderr, "[USAGE ERROR] File path required\n");
return 1;
```
- **`fprintf(stderr, ...)`**: 通常の `printf` は `stdout`（標準出力）に文字を送るが、`fprintf(stderr, ...)` は `stderr`（標準エラー出力）専用のパイプに文字を送る。
- **終了コード（Exit Code）**:
  - `0`: 正常終了
  - `1`: ユーザーの使い方ミス（引数不足など）
  - `2`: ファイル読み込みやIOの致命的エラー

```c
if (stat(filepath, &st) == 0 && S_ISDIR(st.st_mode)) {
    fprintf(stderr, "[IO ERROR] Target is a directory\n");
    return 2;
}
```
- 第8層で学んだ `stat` を使い、渡されたパスが「ファイルではなくフォルダ」だった場合に、不正な読み込みを行わずに即座に弾くガード処理。

```c
fprintf(stderr, "[IO ERROR] %s\n", strerror(errno));
```
- **`errno`**: `fopen` などのシステム関数が失敗したとき、OSが「なぜ失敗したのか」の理由番号（例: 2 = No such file, 13 = Permission denied）を書き込む特別な変数。
- **`strerror(errno)`**: そのエラー番号を、`"No such file or directory"` といった英語の分かりやすいメッセージに自動翻訳してくれる関数。

```c
int ch;
while ((ch = fgetc(fp)) != EOF)
```
- **なぜ `char` ではなく `int` 型なのか？**:
  - `fgetc` はファイルから1バイト（`0`〜`255`）を取り出すが、ファイルの終端に達した時は特別な記号 **`EOF`（通常 `-1`）** を返す。
  - もし `char` 型で受け取ると、文字コード `255` と `EOF (-1)` が混同して判定が狂い、無限ループに陥る危険があるため、C言語規格では必ず `int` 型で受けるのが鉄則である。

---

## 📖 【カタカナ英語ルビ辞典 (Ruby Words)】
プログラミングに出てくる難解な英単語を日本語でイメージせよ。

| 単語 | 読み方 | 意味・役割 |
| :--- | :--- | :--- |
| **`stdout`** | エス・ティー・ディー・アウト (standard output) | 標準出力。正常な計算結果やデータを流すパイプ。 |
| **`stderr`** | エス・ティー・ディー・エラー (standard error) | 標準エラー出力。警告やエラー通知を流す緊急用パイプ。 |
| **`errno`** | エラー・ナンバー (error number) | OSがエラーの原因番号を記録するグローバル変数。 |
| **`strerror`** | ストリング・エラー (string error) | エラー番号を人間が読める英文に翻訳する関数。 |
| **`EOF`** | イー・オー・エフ (End Of File) | ファイルの終端を示す目印記号（値は -1）。 |
| **`fgetc`** | エフ・ゲット・シー (file get char) | ファイルから1文字（1バイト）読み出す関数。 |
| **`fclose`** | エフ・クローズ (file close) | 開いたファイルを安全に閉じる関数。 |

---

## 💡 【これが実際の開発でどう使えるか】
なぜ UNIX では `stdout` と `stderr` を厳格に分けるのか？
ターミナルで以下のようなコマンドを打った時を想像してほしい：
```bash
gear stat > result.txt 2> error.log
```
- `>` は標準出力を `result.txt` に保存する。
- `2>` は標準エラー出力を `error.log` に保存する。
もしエラーメッセージを `printf`（`stdout`）で出力してしまうと、正常なデータファイルの中に「エラーです！」というゴミ文字が混ざり、後続のプログラムが壊れてしまう。
**「データは stdout へ、警告は stderr へ」**——これが50年間守られ続けるUNIX哲学の神髄である。

---

## ⚠️ 【初心者が絶対にハマる3大トラップ】

1. **トラップ1: エラー出力を `printf` で書いてしまう！**
   - エラーを `printf(...)` で出力すると、標準出力（stdout）に流れてしまい、自動採点テストで「エラーが正しく出力されていない」と判定されます。必ず `fprintf(stderr, ...)` を使ってください。
2. **トラップ2: `ch` を `char` 型にしてしまい `EOF` 判定が狂う！**
   - `char ch = fgetc(fp)` と書くと、ファイル末尾を検知できず無限ループに陥ります。必ず `int ch;` と宣言してください。
3. **トラップ3: `fclose` の呼び忘れ！**
   - ファイルを開いたまま放置すると、他のプロセスがそのファイルを編集できなくなったり、リソース枯渇を引き起こします。

---

## 🎯 【ボス戦クリア目標＆ステップ・バイ・ステップ写経ガイド】

`Floor_09_IronWall/main.c` を開き、以下の完成コードを記述せよ。

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/stat.h>

int main(int argc, char *argv[]) {
    // ステップ1: 引数の確認 (不足時は stderr に出力して exit 1)
    if (argc < 2) {
        fprintf(stderr, "[USAGE ERROR] File path required\n");
        return 1;
    }

    const char *filepath = argv[1];
    struct stat st;

    // ステップ2: ディレクトリの誤指定判定 (stat & S_ISDIR)
    if (stat(filepath, &st) == 0 && S_ISDIR(st.st_mode)) {
        fprintf(stderr, "[IO ERROR] Target is a directory\n");
        return 2;
    }

    // ステップ3: ファイルオープンとエラーハンドリング (fopen & strerror(errno))
    FILE *fp = fopen(filepath, "r");
    if (fp == NULL) {
        fprintf(stderr, "[IO ERROR] %s\n", strerror(errno));
        return 2;
    }

    // ステップ4: 行数カウント (int ch で受けて EOF までループ)
    long lines = 0;
    int ch;
    while ((ch = fgetc(fp)) != EOF) {
        if (ch == '\n') {
            lines++;
        }
    }

    // ステップ5: ファイルクローズと結果出力
    fclose(fp);

    printf("LINES: %ld\n", lines);
    return 0;
}
```

---

## 4. クリア手順（ターミナルで実行）

1. 模範解答でテスト（事前検証）：
   ```bash
   ./test.sh --solution
   ```
   `【判定】 CLEARED!` と表示されることを確認せよ。

2. 受講者用コード `main.c` を編集：
   ガイドに従ってエラー処理と行数カウントを完成させよ。

3. ボス戦（自動採点スクリプト）に挑む：
   ```bash
   ./test.sh
   ```
   引数不足・存在しないファイル・権限エラー・ディレクトリ指定の全5パターンの堅牢性テストを突破し、緑色の文字で `【判定】 CLEARED!` が出れば第9層突破だ！
