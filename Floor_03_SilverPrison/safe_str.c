#include <string.h>
#include "safe_str.h"

int safe_str_copy(char *dest, size_t dest_size, const char *src) {
    /* 【実装ヒント】
     * 1. 防御的チェック:
     *    dest が NULL、src が NULL、または dest_size が 0 の場合は即座に -1 を返す。
     * 2. 文字列の長さを計測:
     *    size_t src_len = strlen(src);
     * 3. バッファに収まる場合 (src_len < dest_size):
     *    memcpy(dest, src, src_len + 1) や 1文字ずつのループで全文字（'\0'含む）をコピーし、0 を返す。
     * 4. バッファを超える場合 (src_len >= dest_size):
     *    先頭から (dest_size - 1) 文字だけをコピーし、
     *    必ず最後に dest[dest_size - 1] = '\0'; で終端させて、切り詰め発生を示す 1 を返す。
     */
    /* TODO: 上記ヒントに従い、安全な文字列コピーを実装せよ */
    (void)dest;
    (void)dest_size;
    (void)src;
    return -1;
}

int safe_path_join(char *dest, size_t dest_size, const char *dir, const char *file) {
    /* 【実装ヒント】
     * 1. 防御的チェック:
     *    dest, dir, file のいずれかが NULL、または dest_size が 0 なら -1 を返す。
     * 2. 必要サイズの計算:
     *    dir の末尾に '/' があるかどうかでスラッシュ付与の要否を判定し、
     *    必要な合計文字数 (dir_len + (slash ? 0 : 1) + file_len + 1) が dest_size を超えるなら -1 を返す。
     * 3. 結合と終端:
     *    dir をコピーし、必要に応じて '/' を追加し、続いて file をコピーして末尾に '\0' を付与する。
     */
    /* TODO: 上記ヒントに従い、安全なパス結合を実装せよ */
    (void)dest;
    (void)dest_size;
    (void)dir;
    (void)file;
    return -1;
}
