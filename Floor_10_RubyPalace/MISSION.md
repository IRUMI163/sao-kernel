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

## 1. この階層で学ぶC言語とPOSIXカーネルの核心

最上層である第10層では、C言語標準ライブラリの枠を超え、POSIX規格で定められたOSカーネル直結のシステムコール（System Call）と、プロダクションビルドにおけるコンパイラ最適化・デプロイ技術を修得します。

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

---

### ① `<sys/utsname.h>` : システム情報の取得 `uname()`

OSの名前、ノード名、カーネルバージョン、ハードウェアアーキテクチャなどの低レイヤ情報を取得するには、`<sys/utsname.h>` に定義された `uname()` 関数を使用します。

#### 構造体 `struct utsname` の主要メンバー

```c
#include <sys/utsname.h>

struct utsname uts;
if (uname(&uts) == 0) {
    printf("OS Name : %s\n", uts.sysname);  // 例: Linux, Darwin
    printf("Node    : %s\n", uts.nodename); // ホスト名
    printf("Release : %s\n", uts.release);  // カーネルリリース
    printf("Machine : %s\n", uts.machine);  // 例: x86_64, aarch64
}
```

- **`sysname`**: オペレーティングシステムの名前（Linux, Darwin など）。
- **`machine`**: CPUアーキテクチャ識別子（`x86_64`, `aarch64` など）。

---

### ② `<sys/statvfs.h>` : ストレージ統計の取得 `statvfs()`

ディスクやファイルシステムの総容量・使用率を正確に算出するため、`<sys/statvfs.h>` の `statvfs()` を使用します。

```c
#include <sys/statvfs.h>

struct statvfs stat;
if (statvfs(".", &stat) == 0) {
    // 総ブロック数 × ブロックサイズ ＝ 総バイト数
    unsigned long long total_bytes = (unsigned long long)stat.f_blocks * stat.f_frsize;

    // 利用可能ブロック数 × ブロックサイズ ＝ 空きバイト数
    unsigned long long free_bytes  = (unsigned long long)stat.f_bavail * stat.f_frsize;

    // 使用済みバイト数
    unsigned long long used_bytes  = total_bytes - free_bytes;

    // 使用率（パーセンテージ）の計算
    double storage_used = ((double)used_bytes / (double)total_bytes) * 100.0;

    printf("Storage Used: %.1f%%\n", storage_used);
}
```

#### 重要ポイント：
- **`stat.f_blocks`**: ファイルシステムの総ブロック数。
- **`stat.f_bavail`**: 一般ユーザーが利用可能な空きブロック数。
- **`stat.f_frsize`**: 基礎ブロックサイズ（バイト）。
- ゼロ除算（`total_bytes == 0`）を防止するため、計算前に必ずチェックまたは防御コードを入れます。

---

### ③ リリース最適化コンパイル（`-O2` オプション）

開発段階（デバッグ時）では `-g` や `-O0` を指定してコンパイルしますが、本番環境（プロダクション）へデプロイするバイナリでは GCC/Clang の最適化フラグ **`-O2`** を使用します。

```bash
gcc -std=c11 -O2 -Wall -Wextra -Werror -o floor_runner main.c
```

- **`-O2`（Level 2 Optimization）**:
  コードサイズを過剰に膨らませることなく、ループ展開、インライン化、レジスタ割り当ての最適化など、最高クラスの実行速度パフォーマンスを引き出す標準的な最適化レベルです。

---

### ④ 環境変数 `PATH` と `~/.local/bin` へのデプロイ

作成したプログラムをターミナルのどこからでもコマンド名ひとつで呼び出せるようにすることを「デプロイ（Deploy）」と呼びます。

```bash
# 1. ユーザーローカル用の実行ファイルディレクトリを作成
mkdir -p ~/.local/bin

# 2. ビルドしたバイナリを配置
cp gear ~/.local/bin/gear

# 3. SHELLの設定ファイル（~/.bashrc または ~/.zshrc）に PATH を追加
export PATH="$HOME/.local/bin:$PATH"
```

これにより、コマンドラインで `./gear` ではなく `gear` と打つだけでプログラムが起動するようになります。

---

## 2. 現場で飛び交う業界用語辞典

- **POSIX (Portable Operating System Interface)**:
  UNIX系OS（Linux, macOS, BSDなど）間でプログラムの互換性を保つための標準規格。`uname()` や `statvfs()` は POSIX 準拠のシステムコールである。
- **システムコール (System Call)**:
  ユーザープログラムがOSのカーネル機能（ファイル操作、メモリ確保、ハードウェアアクセス）を呼び出すための特殊な命令。
- **デプロイ (Deployment)**:
  開発・ビルドしたソフトウェアを実行環境に配置し、エンドユーザーが利用可能な状態にすること。
- **インライン展開 (Function Inlining)**:
  コンパイラの最適化機能（`-O2`など）の一つ。関数呼び出しのオーバーヘッドを無くすため、関数の中身を実行場所に直接埋め込む手法。
- **バイナリストリッピング (Strip)**:
  コンパイルされた実行ファイルからデバッグ用シンボル情報を削ぎ落とし、ファイルサイズを最小化する工程。

---

## 3. ボス戦ミッション（最終実装仕様）

`Floor_10_RubyPalace/main.c` を編集し、`uname()` と `statvfs()` から実機システム情報を取得し、SAO風ヘッダーおよび以下のクリア認定証（アスキーアート）を出力する最終プログラムを完成させよ。

### 要求される出力フォーマット

```text
==================================================
  [AINCRAD SYSTEM] : RUBY PALACE - FINAL CLEAR
==================================================
OS      : <実機のsysname> (<実機のmachine>)
STORAGE : <実機のディスク使用率> USED
--------------------------------------------------
      /\
     /  \       SWORD ART ONLINE : KERNEL
    / /\ \      =========================
   / /  \ \     CLEAR CERTIFICATE
  / /____\ \
 / ________ \   PLAYER : KIRITO
/ /        \ \  RANK   : S [MASTER OF KERNEL]
==================================================
```

#### 具体的な出力例（Linux x86_64 環境の場合）
```text
==================================================
  [AINCRAD SYSTEM] : RUBY PALACE - FINAL CLEAR
==================================================
OS      : Linux (x86_64)
STORAGE : 42.5% USED
--------------------------------------------------
      /\
     /  \       SWORD ART ONLINE : KERNEL
    / /\ \      =========================
   / /  \ \     CLEAR CERTIFICATE
  / /____\ \
 / ________ \   PLAYER : KIRITO
/ /        \ \  RANK   : S [MASTER OF KERNEL]
==================================================
```

### 仕様詳細

1. **ヘッダー表示**:
   `SAO_PRINT_HEADER("RUBY PALACE - FINAL CLEAR");` を使用すること。
2. **OS情報の出力**:
   `uname()` で取得した `sysname` と `machine` を `"OS      : %s (%s)\n"` の形式で出力すること。
3. **ストレージ情報の出力**:
   `statvfs(".")` を使用してカレントディレクトリが存在するディスクの総容量と使用量を計算し、`"STORAGE : %.1f%% USED\n"` の形式で小数点以下1桁のパーセンテージで出力すること。
4. **区切り線**:
   `--------------------------------------------------\n` (ハイフン50個) を出力すること。
5. **クリア認定証（SAO風アスキーアート）**:
   以下の行をそのまま出力すること。
   ```text
         /\
        /  \       SWORD ART ONLINE : KERNEL
       / /\ \      =========================
      / /  \ \     CLEAR CERTIFICATE
     / /____\ \
    / ________ \   PLAYER : KIRITO
   / /        \ \  RANK   : S [MASTER OF KERNEL]
   ```
6. **フッター表示**:
   `SAO_PRINT_FOOTER();` を使用すること。

---

## 4. クリア手順（ターミナルで実行）

1. **手動でビルドとテストを行う場合**:
   ```bash
   gcc -std=c11 -O2 -Wall -Wextra -Werror -o floor_runner main.c
   ./floor_runner
   ```

2. **最終ボス戦（自動採点スクリプト）に挑む場合**:
   ```bash
   ./test.sh
   ```
   緑色の文字で `【判定】 CLEARED!` と表示され、アインクラッド全10層の攻略が完了する！

3. **模範解答の検証（メンテナー・採点者用）**:
   ```bash
   ./test.sh --solution
   ```

4. **ボーナスステージ：すべての階層を突破したら、`cd ../gear && make && ./gear stat` を実行し、君たちの手で組み上げた万能CLIツール『`gear`』を目覚めさせよ！**

---

> **茅場晶彦**:
> 「見事だ。君のコードは今やシステムと一体化し、アインクラッドの最上層に刻まれた。
> これより君を『マスター・オブ・カーネル』と認定する。
> さあ、全階層の記憶を携え、現実のソフトウェア開発という広大な世界へリンクスタートせよ！」
