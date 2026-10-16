# 【第10層：紅玉宮（最終試験）】〜完全なるデプロイ〜

> **茅場晶彦からの最終通達**:
> 「よくぞここまで辿り着いた、勇敢なるプログラマたちよ。
> ここは浮遊城アインクラッド最上層、紅玉宮。
> 君たちが第1層で初めて『Hello World』の洗礼を受けてから、幾多の構造体、ポインタの罠、メモリ管理の深淵を潜り抜けてきた。
>
> だが、ただコードを書くだけでは本物の『システム開発者』とは言えない。
> 記述したプログラムを極限まで最適化し、オペレーティングシステムの深層（カーネル）から直接情報を汲み上げ、
> ユーザーの実行環境（`PATH`）へ正しくデプロイして初めて、君たちのプロダクトは命を宿すのだ。
>
> これが最後の試験となる。
> 浮遊城のシステム核（カーネル）に直接システムコールを打ち込み、全領域のクリア認定証を刻印せよ！」

---

## 🎴 【基本構文パターン (Pattern Example)】
迷ったらまずこの型を見よ。第10層で使う武器はこれだけだ。

```c
/* パターンA: OS情報の取得 (uname システムコール) */
struct utsname uts;
if (uname(&uts) != 0) return 1;
printf("OS      : %s (%s)\n", uts.sysname, uts.machine);

/* パターンB: ディスク容量と使用率の計算 (statvfs システムコール) */
struct statvfs stat;
if (statvfs(".", &stat) != 0) return 1;

double storage_used = 0.0;
if (stat.f_blocks > 0) {
    double total_bytes = (double)stat.f_blocks * (double)stat.f_frsize;
    double free_bytes  = (double)stat.f_bavail * (double)stat.f_frsize;
    double used_bytes  = total_bytes - free_bytes;
    storage_used = (used_bytes / total_bytes) * 100.0;
}
printf("STORAGE : %.1f%% USED\n", storage_used);

/* パターンC: C言語文字列でバックスラッシュ \ を出力するお約束 */
printf("      /\\\n"); // 文字列中で \ を出すには \\ と2個並べる！
```

---

## 🔍 【エディタに開いているコードの1行ずつ完全解体新書】
`main.c` に書かれているコードを1文字残らず分解・解説する。

```c
#include <sys/utsname.h>
#include <sys/statvfs.h>
#include "../shared/sao_ui.h"
```
- **`<sys/utsname.h>`**: OSの名前やCPUの種類を取得するシステムコール `uname()` を使うためのPOSIXヘッダ。
- **`<sys/statvfs.h>`**: ディスクの残容量やファイルシステムの統計を取得するシステムコール `statvfs()` を使うためのPOSIXヘッダ。
- **`"../shared/sao_ui.h"`**: アインクラッドの美しい装飾枠線を出力する共通マクロ群（`SAO_PRINT_HEADER` など）。

```c
struct utsname uts;
uname(&uts);
```
- **`uname`（ユーネーム）**: OSカーネルに「君の名前とマシン構成を教えてくれ」と直接問い合わせるシステムコール。
- 引数に構造体のアドレス `&uts` を渡すことで、カーネルが構造体の中に `sysname`（例: `"Darwin"` や `"Linux"`）と `machine`（例: `"arm64"` や `"x86_64"`）を書き込んでくれる。

```c
struct statvfs stat;
statvfs(".", &stat);
```
- **`statvfs`（スタット・ブイ・エフ・エス）**: カレントディレクトリ `"."` が存在するハードディスクの容量統計をカーネルから直接吸い上げるシステムコール。
- **`stat.f_blocks`**: ディスク全体のブロック数。
- **`stat.f_bavail`**: 一般ユーザーが使える空きブロック数。
- **`stat.f_frsize`**: 1ブロックあたりのバイト数（通常 4096 バイトなど）。
- 「ブロック数 × 1ブロックのバイト数」を計算することで、ハードディスクの正確な総バイト数や使用率（%）が導き出せる。

```c
printf("      /\\\n");
```
- **なぜ `\\` と2つ書くのか？**:
  - C言語の文字列の中で `\` はエスケープ文字（`\n` で改行、`\0` でヌル文字など）として扱われる。
  - そのため、純粋な記号としての `\` を1文字画面に表示したい時は、`\\` と2回連続で書かなければならない。

---

## 📖 【カタカナ英語ルビ辞典 (Ruby Words)】
プログラミングに出てくる難解な英単語を日本語でイメージせよ。

| 単語 | 読み方 | 意味・役割 |
| :--- | :--- | :--- |
| **`uname`** | ユーネーム (UNIX name) | OS名やCPUアーキテクチャを取得するシステムコール。 |
| **`statvfs`** | スタット・ブイ・エフ・エス | 仮想ファイルシステム（ディスク）の容量情報を調べる関数。 |
| **`system call`** | システムコール | ユーザープログラムがOSの心臓部（カーネル）に直接依頼する命令。 |
| **`deploy`** | デプロイ (配備・展開) | 作成したバイナリをユーザーがどこからでも実行できる場所に配置すること。 |
| **`PATH`** | パス (環境変数) | コマンド名だけを打ったときに、OSが実行ファイルを探しに行くディレクトリ一覧。 |
| **`ASCII Art`** | アスキーアート (AA) | アルファベットや記号文字だけで描かれたグラフィック絵。 |
| **`-O2`** | オー・ツー (Optimization Level 2) | コンパイラに「限界まで高速に動く機械語に変換せよ」と命じる最適化フラグ。 |

---

## 💡 【これが実際の開発でどう使えるか】
ターミナルでよく使われる `uname -a`, `df -h`（ディスク残量確認）, `htop`, `neofetch`。
これらの有名システムツールは、内部で一体何をやっているのか？
まさに今回君が使った `uname()` と `statvfs()` を呼び出し、OSカーネルから直接データを吸い上げて画面に整形出力しているのだ。君は今、本物のシステム管理ツールの心臓部を自らの手で完成させたのである。

---

## 1. この階層で学ぶC言語とPOSIXカーネルの核心

```
 +-------------------------------------------------------+
 |                 User Application (gear)              |
 +-------------------------------------------------------+
             |                               |
    uname()  | System Call          statvfs()| System Call
             v                               v
 +-------------------------------------------------------+
 |                  OS Kernel (POSIX)                    |
 +-------------------------------------------------------+
 |  System Information  |      Virtual File System       |
 |  (sysname, machine)  |  (f_blocks, f_bavail, f_bsize) |
 +-------------------------------------------------------+
```

### 環境変数 `PATH` と `~/.local/bin` へのデプロイ
```bash
# 1. ユーザーローカル用の実行ファイルディレクトリを作成
mkdir -p ~/.local/bin

# 2. ビルドしたバイナリを配置
cp gear ~/.local/bin/gear

# 3. ターミナルのどこからでも gear で起動可能になる！
```

---

## ⚠️ 【初心者が絶対にハマる3大トラップ】

1. **トラップ1: アスキーアートのバックスラッシュ `\` エスケープ漏れ！**
   - 文字列中で `\` を1個だけ書くと、コンパイラが「未知のエスケープシーケンス」と警告を出し、アスキーアートが崩れます。必ず `\\` と2個重ねてください。
2. **トラップ2: ゼロ除算の考慮漏れ！**
   - 特殊な仮想環境で `stat.f_blocks` が 0 の場合、割り算するとCPUクラッシュします。必ず `if (stat.f_blocks > 0)` の中で計算してください。
3. **トラップ3: `uname` や `statvfs` にアドレス `&` を渡し忘れる！**
   - これらの関数は、渡された構造体にカーネルが結果を書き込むため、実体ではなくポインタ（`&uts`, `&stat`）を渡さなければなりません。

---

## 🎯 【ボス戦クリア目標＆ステップ・バイ・ステップ写経ガイド】

`Floor_10_RubyPalace/main.c` を開き、以下の完成コードを記述せよ。

```c
#include <stdio.h>
#include <sys/utsname.h>
#include <sys/statvfs.h>
#include "../shared/sao_ui.h"

int main(void) {
    // ステップ1: uname システムコールでOS情報を取得
    struct utsname uts;
    if (uname(&uts) != 0) {
        return 1;
    }

    // ステップ2: statvfs システムコールでディスク容量を取得
    struct statvfs stat;
    if (statvfs(".", &stat) != 0) {
        return 1;
    }

    // ステップ3: ストレージ使用率（%）を計算
    double storage_used = 0.0;
    if (stat.f_blocks > 0) {
        double total_bytes = (double)stat.f_blocks * (double)stat.f_frsize;
        double free_bytes  = (double)stat.f_bavail * (double)stat.f_frsize;
        double used_bytes  = total_bytes - free_bytes;
        storage_used = (used_bytes / total_bytes) * 100.0;
    }

    // ステップ4: SAOヘッダーおよびシステム情報の出力
    SAO_PRINT_HEADER("RUBY PALACE - FINAL CLEAR");

    printf("OS      : %s (%s)\n", uts.sysname, uts.machine);
    printf("STORAGE : %.1f%% USED\n", storage_used);
    printf("--------------------------------------------------\n");

    // ステップ5: クリア認定証（バックスラッシュ \\ に注意）
    printf("      /\\\n");
    printf("     /  \\       SWORD ART ONLINE : KERNEL\n");
    printf("    / /\\ \\      =========================\n");
    printf("   / /  \\ \\     CLEAR CERTIFICATE\n");
    printf("  / /____\\ \\    \n");
    printf(" / ________ \\   PLAYER : KIRITO\n");
    printf("/ /        \\ \\  RANK   : S [MASTER OF KERNEL]\n");

    // ステップ6: SAOフッターの出力と正常終了
    SAO_PRINT_FOOTER();

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
   ガイドに従ってシステムコール呼び出しと認定証出力を完成させよ。

3. 最終ボス戦（自動採点スクリプト）に挑む：
   ```bash
   ./test.sh
   ```
   `-O2` リリースビルドの洗礼を通過し、緑色の文字で `【判定】 CLEARED!` が出ればアインクラッド全10層完全制覇だ！

4. **ボーナスステージ**:
   すべての階層を突破したら、リポジトリのルートで以下を実行し、君たちの手で完成させた万能CLIツール『`gear`』を目覚めさせよ！
   ```bash
   cd gear && make && ./gear stat
   ```

---

> **茅場晶彦**:
> 「見事だ。君のコードは今やシステムと一体化し、アインクラッドの最上層に刻まれた。
> これより君を『マスター・オブ・カーネル』と認定する。
> さあ、全階層の記憶を携え、現実のソフトウェア開発という広大な世界へリンクスタートせよ！」
