# 【第4層：迷宮区の製図室】〜職人の分離術〜

> **茅場晶彦からのシステム通達**:
> 「巨大な城郭アインクラッドを単一の設計図で記述することは不可能だ。
> 優れた職人は、城壁、部屋、仕掛けの設計図をそれぞれ独立した羊皮紙に分割し、最後にひとつへと組み上げる。
> 君たちのプログラムも同様だ。すべてのコードを単一のファイルに詰め込む雑な設計は、予期せぬ混乱とバグを招く。
> この第4層『製図室』で、関数分割、プロトタイプ宣言、ヘッダファイル、そしてビルドを自動化する `Makefile` の技術を習得し、真の構造化設計を手にするのだ」

---

## 🎴 【基本構文パターン (Pattern Example)】
迷ったらまずこの型を見よ。第4層で使う武器はこれだけだ。

```c
/* パターンA: ヘッダファイルの絶対的掟（インクルードガード） */
#ifndef CALC_H
#define CALC_H

// ここに関数の「看板」（プロトタイプ宣言。末尾にセミコロン ; を忘れるな）を書く
int calc_storage_percent(long used, long total);
int calc_player_rank(int score);

#endif /* CALC_H */
```

```c
/* パターンB: ゼロ除算防御（分母が0なら計算せずエラーを返す） */
if (total <= 0) {
    return -1; // 0で割るとCPUがクラッシュするため事前に弾く
}
return (int)((used * 100) / total);
```

```makefile
# パターンC: Makefile の黄金ルール（コマンド行頭は必ず [TAB] キー！）
ターゲット名: 必要な依存ファイル群
	実行するコンパイルコマンド
```

---

## 🔍 【エディタに開いているコードの1行ずつ完全解体新書】
`calc.h`, `calc.c`, `Makefile` に書かれているコードを1行ずつ完全解剖する。

### 1. `calc.h`（設計図・看板）
- **`#ifndef CALC_H`**: 「もし（if）`CALC_H` という名前がまだ定義されていないなら（not defined）」という意味のプリプロセッサ命令。
- **`#define CALC_H`**: `CALC_H` を定義済みにする。これにより、同じファイルが2回以上読み込まれても中身が二重に展開されない（インクルードガード）。
- **`int calc_storage_percent(long used, long total);`**: 関数の看板（プロトタイプ宣言）。
  - 中身 `{ ... }` は書かず、末尾にセミコロン `;` を打つ。
  - コンパイラに「あとでこういう名前・引数・戻り値の関数が登場するから覚えておいてね」と教える。
- **`#endif /* CALC_H */`**: `#ifndef` の判定ブロックの終了地点。

### 2. `calc.c`（職人の実作業・本体）
- **`#include "calc.h"`**: 自分が実装する看板を自ら読み込む。二重引用符 `""` は「自分自身のプロジェクトフォルダ内のファイル」を探す合図。
- **`long used, long total`**: `int`（通常32bit）よりも巨大な数値を扱える64bit整数型。ストレージ容量などの計算に適している。
- **`(void)used;`**: 未使用警告を防ぐためのおまじない。実装を書いたら消してよい。

### 3. `Makefile`（自動化の脚本）
- **`CC = gcc`**: コンパイラとして `gcc` を使うという変数定義。
- **`CFLAGS = -std=c11 -Wall -Wextra -Werror`**: コンパイル時の警告・規約オプション。
- **`all: floor_runner`**: `make` とだけ打ったときに、デフォルトで `floor_runner` を作るという指示。
- **`clean:`**: `make clean` を実行したときに一時ファイル（`.o`）やバイナリを一括削除するお掃除ルール。

---

## 📖 【カタカナ英語ルビ辞典 (Ruby Words)】
プログラミングに出てくる難解な英単語を日本語でイメージせよ。

| 単語 | 読み方 | 意味・役割 |
| :--- | :--- | :--- |
| **`ifndef`** | イフ・ノット・ディファイン (if not defined) | 「もし定義されていなければ」という条件分岐。 |
| **`define`** | ディファイン (define) | 定義する。名前を登録する。 |
| **`endif`** | エンド・イフ (end if) | if判定ブロックの終了合図。 |
| **`prototype`** | プロトタイプ (prototype declaration) | 原型、試作機。関数の型と名前だけを先に見せる宣言。 |
| **`header`** | ヘッダ (`.h` / header file) | 頭部。関数の看板や共通設定をまとめて書くファイル。 |
| **`module`** | モジュール (module) | 交換可能な部品。機能ごとにまとめたプログラムの塊。 |
| **`linker`** | リンカ (linker) | つなぐもの。バラバラの部品（`.o`）を接着して1つの完成品にする。 |
| **`tab`** | タブ (Tab key) | Makefileのコマンド行頭に必須の不可視文字（スペース4個では動かない）。 |

---

## 💡 【これが実際の開発でどう使えるか】
なぜプログラマはファイルを分割し、`Makefile` を使うのか？
もしLinuxカーネル（数千万行）やゲームエンジンがたった1つの巨大な `main.c` に書かれていたらどうなるか？
- 1文字修正するだけで、全体の再コンパイルに数時間かかる。
- チーム開発で同じファイルを全員が触り、毎日Gitで修復不可能な衝突（コンフリクト）が起きる。

ファイルを `calc.c`, `player.c`, `render.c` と分割し、`calc.h` という看板（インターフェース）を通じて接続すれば：
- 担当者は自分の担当ファイルだけを編集・コミットできる。
- `make` は「修正されたファイルだけ」を0.1秒でコンパイルし、最後にリンカで結合する。
これが世界中のすべてのソフトウェア開発を支える**「分割統治（Divide and Conquer）」**の真髄である。

---

## 1. この階層で学ぶC言語の核心

### ① 関数分割とプロトタイプ宣言
処理のかたまりを独立した「関数」として切り出すことを**関数分割**と呼びます。
C言語では、コンパイラはコードを**上から下へ**順に読み進めます。そのため、関数の看板（プロトタイプ宣言）を先に提示しなければなりません。

```c
#include <stdio.h>

// プロトタイプ宣言（関数の「看板」を前に立てておく）
int calc_sum(int a, int b);

int main(void) {
    int total = calc_sum(10, 20); // コンパイラは関数の型と引数を知っているためOK
    printf("Total: %d\n", total);
    return 0;
}

// 関数の実体（本体）の定義
int calc_sum(int a, int b) {
    return a + b;
}
```

---

### ② ヘッダファイル（`.h`）と `#include`
別の `.c` ファイルで定義された関数を呼び出したい場合、看板をまとめた**ヘッダファイル（`.h`）**を用意します。

- **`calc.h`** : プロトタイプ宣言を記述する。
- **`calc.c`** : 関数の「中身（処理）」を記述する。
- **`main.c`** : `#include "calc.h"` を書き、関数を呼び出す。

---

### ③ インクルードガード（`#ifndef`）の絶対的役割
同じヘッダファイルが多重に読み込まれると、多重定義エラーが発生します。
これを防ぐため、ヘッダファイルは必ず以下のお決まりの枠組みで囲みます。

```c
#ifndef CALC_H
#define CALC_H

// ここにプロトタイプ宣言を書く

#endif /* CALC_H */
```

---

## ⚠️ 【初心者が絶対にハマる3大トラップ】

1. **トラップ1: `Makefile` の行頭をスペースで打ってしまう！**
   - Makefileのコマンド行頭は、絶対に **[TAB] キー** でなければなりません。
   - スペースでインデントすると `Makefile: line: *** missing separator. Stop.` という冷酷なエラーで弾かれます。
2. **トラップ2: プロトタイプ宣言末尾のセミコロン `;` 忘れ！**
   - 関数の看板（`int calc_player_rank(int score);`）は、中身 `{ }` を書かない代わりに必ず末尾に `;` を付けます。
3. **トラップ3: ゼロ除算 (Zero Division Error)！**
   - コンピュータは `100 / 0` を計算できません（CPU例外が発生して即死クラッシュします）。
   - 割り算をする前に必ず `if (total <= 0) return -1;` とチェックするのがプロの鉄則です。

---

## 🎯 【ボス戦クリア目標＆ステップ・バイ・ステップ写経ガイド】

### 武器①: `calc.h` の完成
`calc.h` を開き、インクルードガードと関数の看板を記述せよ。
```c
#ifndef CALC_H
#define CALC_H

int calc_storage_percent(long used, long total);
int calc_player_rank(int score);

#endif /* CALC_H */
```

### 武器②: `calc.c` の完成
`calc.c` を開き、2つの計算ロジックを実装せよ。
```c
#include "calc.h"

int calc_storage_percent(long used, long total) {
    // 1. total が 0 以下なら計算不能なのでエラー (-1) を返す
    if (total <= 0) {
        return -1;
    }
    // 2. 整数除算でパーセントを計算
    return (int)((used * 100) / total);
}

int calc_player_rank(int score) {
    // スコアに応じて高い順に判定してランク (3, 2, 1, 0) を返す
    if (score >= 1000) {
        return 3;
    } else if (score >= 500) {
        return 2;
    } else if (score >= 100) {
        return 1;
    } else {
        return 0;
    }
}
```

### 武器③: `Makefile` の完成
`Makefile` に `floor_runner` をビルドするルールを記述せよ（行頭は必ず [TAB] キー）。
```makefile
CC = gcc
CFLAGS = -std=c11 -Wall -Wextra -Werror

all: floor_runner

floor_runner: main.o calc.o
	$(CC) $(CFLAGS) -o floor_runner main.o calc.o

main.o: main.c calc.h
	$(CC) $(CFLAGS) -c main.c -o main.o

calc.o: calc.c calc.h
	$(CC) $(CFLAGS) -c calc.c -o calc.o

clean:
	rm -f *.o floor_runner
```

---

## 4. クリア手順（ターミナルで実行）

1. 模範解答でテスト（事前検証）：
   ```bash
   ./test.sh --solution
   ```
   `【判定】 CLEARED!` と表示されることを確認せよ。

2. 受講者用コードを編集：
   `calc.h`, `calc.c`, `Makefile` を完成させよ。

3. ボス戦（自動採点スクリプト）に挑む：
   ```bash
   ./test.sh
   ```
   緑色の文字で `【判定】 CLEARED!` が出れば第4層突破だ！
