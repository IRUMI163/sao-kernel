#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/stat.h>

int main(int argc, char *argv[]) {
    /* TODO: 1. 引数チェック
     * argc < 2 の場合、stderr に "[USAGE ERROR] File path required\n" と出力し、
     * 終了コード 1 で終了せよ。
     */
    if (argc < 2) {
        /* TODO: stderr への出力と exit(1) または return 1 */
        return 0; // 現在は不完全な処理
    }

    const char *filepath = argv[1];
    struct stat st;

    /* TODO: 2. ディレクトリ判定
     * stat(filepath, &st) == 0 かつ S_ISDIR(st.st_mode) の場合、
     * stderr に "[IO ERROR] Target is a directory\n" と出力し、
     * 終了コード 2 で終了せよ。
     */
    if (stat(filepath, &st) == 0 && S_ISDIR(st.st_mode)) {
        /* TODO: stderr への出力と exit(2) または return 2 */
        return 0;
    }

    /* TODO: 3. ファイルオープンとエラー処理
     * fopen(filepath, "r") でファイルを開く。
     * NULL が返された場合（ファイル非存在や権限不足）、
     * stderr に "[IO ERROR] <strerror(errno)>\n" と出力し、
     * 終了コード 2 で終了せよ。
     */
    FILE *fp = fopen(filepath, "r");
    if (fp == NULL) {
        /* TODO: stderr への出力と exit(2) または return 2 */
        return 0;
    }

    /* TODO: 4. 行数カウントと stdout 出力
     * ファイルの内容を読み込んで行数をカウントし、
     * stdout に "LINES: <行数>\n" と出力せよ。
     * 処理完了後は fclose(fp) を行い、終了コード 0 を返せ。
     */
    fclose(fp);

    return 1; // TODO: 正しい実装では 0 を返す
}
