# 【第7層：記憶の断頭台】〜動的メモリ確保と解放〜

> **茅場晶彦からのシステム通達**:
> 「プレイヤー諸君、ようこそ第7層『記憶の断頭台』へ。
> これまで君たちが扱ってきた変数は、関数の終わりとともに自動的に消滅する『スタック』という名の小さな机の上に過ぎなかった。
> だが、巨大なダンジョンのデータや、サイズが予測できない数千のアイテムリストを扱うには、広大な大地——『ヒープ（Heap）』からメモリを直接切り拓かねばならない。
>
> `malloc` でメモリを召喚し、`free` で確実に冥府へと還す。
> もし返還を一度でも怠れば、『メモリリーク』という名の毒が城の息の根を止め、
> 既に還したメモリを再び触れれば、『Use-After-Free』の断頭台の刃が容赦なく君の首を落とすだろう。
> メモリの生と死を司る者となれ。AddressSanitizerが君のカルマ（解放漏れ）を常に見張っている」

---

## 🎴 【基本構文パターン (Pattern Example)】
迷ったらまずこの型を見よ。第7層で使う武器はこれだけだ。

```c
/* パターンA: メモリを確保して NULL チェック (malloc) */
Type *ptr = (Type *)malloc(sizeof(Type) * 個数);
if (ptr == NULL) {
    return -1; // メモリ不足時は即座にエラーを返す
}

/* パターンB: 配列が満杯になったら容量を2倍に拡張 (realloc) */
if (count >= capacity) {
    size_t new_cap = capacity * 2;
    Type *new_ptr = (Type *)realloc(ptr, sizeof(Type) * new_cap);
    if (new_ptr == NULL) return -1;
    ptr = new_ptr;
    capacity = new_cap;
}

/* パターンC: 親子構造の解放（必ず「子」を先に free してから「親」を free） */
for (size_t i = 0; i < count; i++) {
    free(items[i].filename); // 子の文字列を解放
    items[i].filename = NULL;
}
free(items); // 親の配列を解放
items = NULL;
```

---

## 🔍 【エディタに開いているコードの1行ずつ完全解体新書】
`file_list.c` と `file_list.h` に書かれているコードを1文字残らず分解・解説する。

### 1. `init_file_list(FileList *list, size_t initial_capacity)`
- **`list->items = (FileItem *)malloc(sizeof(FileItem) * initial_capacity);`**:
  - `malloc` は引数に「確保したい総バイト数」を渡す。
  - `sizeof(FileItem)`（1個あたりのサイズ）× `initial_capacity`（個数）を計算してヒープメモリを確保。
  - 確保に失敗すると `NULL` が返るため、直後の `if (list->items == NULL)` チェックが必須。

### 2. `add_file_item(...)`
- **`if (list->count >= list->capacity)`**:
  - 配列が限界まで埋まったか判定。
- **`realloc(list->items, sizeof(FileItem) * new_capacity)`**:
  - 既存のメモリ領域を保持したまま、新しい大きな領域へと自動でお引越し・拡大してくれる関数。
- **`item->filename = (char *)malloc(strlen(filename) + 1);`**:
  - なぜファイル名をわざわざ個別に `malloc` するのか？
  - ファイル名の長さは `"a.txt"`（5文字）から `"super_long_secret_blueprint.png"`（33文字）まで未知数だからだ。
  - 必ず `strlen(filename) + 1` として終端文字 `\0` のための1バイトを足す。

### 3. `free_file_list(FileList *list)`
- **メモリ解放の絶対順序**:
  - もし先に親である `free(list->items);` を呼んでしまうと、配列の中にあった `items[i].filename` のメモリアドレスが失われ、子メモリを永久に解放できなくなる（メモリリーク）。
  - そのため、**「内側のパーツをすべて `free` してから、最後に外枠を `free` する」**のが鉄則である。
  - 解放後は `NULL` を代入して、誤って再アクセス（Use-After-Free）するのを防ぐ。

---

## 📖 【カタカナ英語ルビ辞典 (Ruby Words)】
プログラミングに出てくる難解な英単語を日本語でイメージせよ。

| 単語 | 読み方 | 意味・役割 |
| :--- | :--- | :--- |
| **`malloc`** | エム・アロック (memory allocation) | メモリ確保。ヒープ領域から指定バイト数の空き地を借りる関数。 |
| **`realloc`** | リ・アロック (re-allocation) | 再確保。既に確保したメモリ領域のサイズを拡大・縮小する関数。 |
| **`free`** | フリー | 解放。使い終わったメモリをOSに返還する関数。 |
| **`memory leak`** | メモリリーク (メモリ漏れ) | 借りたメモリを返却し忘れ、OSの空きメモリが徐々に減って死に至るバグ。 |
| **`heap`** | ヒープ領域 | `malloc` で自由に切り取って使える広大なメモリ空間。 |
| **`stack`** | スタック領域 | 関数の実行中だけ自動で使われ、関数が終わると自動破棄される高速なメモリ机。 |
| **`use-after-free`**| ユーズ・アフター・フリー | `free` して既にOSに返したはずの住所を覗き見・書き換えてしまう致命的バグ。 |

---

## 💡 【これが実際の開発でどう使えるか】
Python の `list.append()`, C++ の `std::vector`, JavaScript の動的配列 `arr.push()`。
これらの言語で「配列のサイズを気にせず無限にデータを追加できる」のはなぜか？
その正体こそ、今回君が実装する**「満杯になったら `realloc` で容量を2倍に拡大する動的配列（Dynamic Array）」**そのものである。現代の全プログラミング言語の心臓部を君は今作っているのだ。

---

## 1. この階層で学ぶC言語の核心

### ① スタック vs ヒープ
- **スタック（Stack）**: コンパイル時にサイズが決定している固定長メモリ。関数を抜けると自動解放される。
- **ヒープ（Heap）**: プログラム実行中に必要なサイズを動的に確保できるメモリ。**プログラマが明示的に `free` するまで絶対に消えない**。

---

## ⚠️ 【初心者が絶対にハマる3大トラップ】

1. **トラップ1: `strlen` に `+ 1` を忘れて `\0` が漏れる！**
   - `malloc(strlen(filename))` と書くと、終端ヌル文字が入らず AddressSanitizer に即座に討伐されます。必ず `+ 1` を忘れないでください。
2. **トラップ2: 親を先に `free` して子の住所を見失う！**
   - `free(list->items)` を先に呼ぶと、各要素の `filename` のアドレスが蒸発し、メモリリークになります。
3. **トラップ3: `malloc` の戻り値 `NULL` チェック漏れ！**
   - メモリが枯渇した際、`malloc` は `NULL` を返します。チェックせずに代入するとクラッシュします。

---

## 🎯 【ボス戦クリア目標＆ステップ・バイ・ステップ写経ガイド】

`Floor_07_Guillotine/file_list.c` を開き、以下の3つの関数を完成させよ。

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "file_list.h"

// 武器①: リストの初期化
int init_file_list(FileList *list, size_t initial_capacity) {
    if (list == NULL || initial_capacity == 0) {
        return -1;
    }
    // initial_capacity 分の FileItem 配列を確保
    list->items = (FileItem *)malloc(sizeof(FileItem) * initial_capacity);
    if (list->items == NULL) {
        return -1;
    }
    list->count = 0;
    list->capacity = initial_capacity;
    return 0;
}

// 武器②: 要素の動的追加と自動リサイズ
int add_file_item(FileList *list, const char *filename, const char *ext, size_t size_bytes) {
    if (list == NULL || list->items == NULL || filename == NULL || ext == NULL) {
        return -1;
    }

    // 満杯なら容量を 2 倍に拡張 (realloc)
    if (list->count >= list->capacity) {
        size_t new_capacity = list->capacity * 2;
        FileItem *new_items = (FileItem *)realloc(list->items, sizeof(FileItem) * new_capacity);
        if (new_items == NULL) {
            return -1;
        }
        list->items = new_items;
        list->capacity = new_capacity;
    }

    FileItem *item = &list->items[list->count];

    // ファイル名用のメモリを確保してコピー (+1 を忘れるな)
    item->filename = (char *)malloc(strlen(filename) + 1);
    if (item->filename == NULL) {
        return -1;
    }
    strcpy(item->filename, filename);

    // 拡張子とサイズを格納
    strncpy(item->extension, ext, sizeof(item->extension) - 1);
    item->extension[sizeof(item->extension) - 1] = '\0';
    item->size_bytes = size_bytes;

    list->count++;
    return 0;
}

// 武器③: 完全解放 (リークゼロ)
void free_file_list(FileList *list) {
    if (list == NULL) {
        return;
    }

    if (list->items != NULL) {
        // 先に内側の全 filename を解放
        for (size_t i = 0; i < list->count; i++) {
            if (list->items[i].filename != NULL) {
                free(list->items[i].filename);
                list->items[i].filename = NULL;
            }
        }
        // 最後に外側の items 配列を解放
        free(list->items);
        list->items = NULL;
    }

    list->count = 0;
    list->capacity = 0;
}
```

---

## 4. クリア手順（ターミナルで実行）

1. 模範解答でテスト（事前検証）：
   ```bash
   ./test.sh --solution
   ```
   `【判定】 CLEARED!` と表示されることを確認せよ。

2. 受講者用コード `file_list.c` を編集：
   ガイドに従ってメモリ管理関数群を完成させよ。

3. ボス戦（自動採点スクリプト）に挑む：
   ```bash
   ./test.sh
   ```
   1,000件の動的追加とASanによるメモリリーク検査（LeakSanitizer）をノーエラーで通過すれば第7層突破だ！
