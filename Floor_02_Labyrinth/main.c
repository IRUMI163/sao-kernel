#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
    (void)argc;
    (void)argv;

    /* TODO: MISSION.md の仕様に従い、コマンドライン引数パースエンジンを実装せよ。
     *
     * 1. 引数が存在しない場合 (argc < 2):
     *    "[ERROR] NO COMMAND SPECIFIED" と標準出力し、終了コード 1 で早期リターン。
     *
     * 2. "./floor_runner -h" の場合 (strcmp(argv[1], "-h") == 0):
     *    "USAGE: gear <stat|memo|clean> [options]" と標準出力し、終了コード 0 で早期リターン。
     *
     * 3. "./floor_runner -v" の場合 (strcmp(argv[1], "-v") == 0):
     *    "GEAR VERSION 1.0.0-aincrad" と標準出力し、終了コード 0 で早期リターン。
     *
     * 4. "./floor_runner memo <単語1> <単語2> ..." の場合 (strcmp(argv[1], "memo") == 0):
     *    - 単語が存在しない場合 (argc == 2):
     *      "[ERROR] EMPTY MEMO" と標準出力し、終了コード 1 で早期リターン。
     *    - 単語が存在する場合 (argc >= 3):
     *      "MEMO: <単語1> <単語2> ..." と第3引数以降をスペース区切りで出力し、終了コード 0 で早期リターン。
     *
     * 5. それ以外の未知のコマンドの場合:
     *    "[ERROR] UNKNOWN COMMAND: <argv[1]>" と標準出力し、終了コード 1 で早期リターン。
     */

    return 1;
}
