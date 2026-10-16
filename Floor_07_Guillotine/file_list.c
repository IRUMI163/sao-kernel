#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "file_list.h"

int init_file_list(FileList *list, size_t initial_capacity) {
    if (list == NULL || initial_capacity == 0) {
        return -1;
    }

    /* TODO: malloc で FileItem 配列を initial_capacity 分確保し、
     * count = 0, capacity = initial_capacity に初期化せよ。
     * 確保失敗時は -1 を返せ。
     */
    (void)list;

    return -1;
}

int add_file_item(FileList *list, const char *filename, const char *ext, size_t size_bytes) {
    if (list == NULL || list->items == NULL || filename == NULL || ext == NULL) {
        return -1;
    }

    /* TODO:
     * 1. count == capacity なら realloc で容量を 2 倍に拡張せよ。
     * 2. item.filename 用のメモリを malloc(strlen(filename) + 1) で確保してコピーせよ。
     * 3. ext を item.extension バッファへコピーせよ (末尾 \0 を確保)。
     * 4. size_bytes を設定し、list->count をインクリメントせよ。
     * メモリ確保失敗時は -1 を返せ。
     */
    (void)ext;
    (void)size_bytes;

    return -1;
}

void free_file_list(FileList *list) {
    if (list == NULL) {
        return;
    }

    /* TODO:
     * 1. items 内の各要素の filename をすべて free せよ。
     * 2. list->items を free せよ。
     * 3. items = NULL, count = 0, capacity = 0 にリセットせよ。
     */
}
