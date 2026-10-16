#include "config.h"
#include <string.h>
#include <stdio.h>

int parse_args(int argc, char *argv[], GearConfig *out_config) {
    /* TODO: 1. 引数チェック (out_config == NULL || argc < 2 なら -1 を返す) */
    (void)argc;
    (void)argv;
    (void)out_config;

    /* TODO: 2. out_config をゼロ初期化し、target_path のデフォルト値として "./dungeon_box" をセット */

    /* TODO: 3. サブコマンド (argv[1]) に応じて設定を行う
     * - "-h" / "--help": CMD_HELP をセットし 0 を返す
     * - "-v" / "--version": CMD_VERSION をセットし 0 を返す
     * - "stat": CMD_STAT をセットし 0 を返す
     * - "memo": CMD_MEMO をセット。引数 argv[2] が存在し空文字でなければ memo_text に格納し 0 を返す。存在しないか空文字なら -1 を返す
     * - "clean": CMD_CLEAN をセット。argv[2] 以降のオプション引数を解析:
     *     "--dry-run": dry_run = true
     *     "--verbose" または "-v": verbose = true
     *     それ以外: target_path を上書き更新
     *     解析完了後 0 を返す
     * - 未知のサブコマンド: -1 を返す
     */

    return -1;
}
