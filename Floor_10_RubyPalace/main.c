#include <stdio.h>
#include <sys/utsname.h>
#include <sys/statvfs.h>
#include "../shared/sao_ui.h"

int main(void) {
    struct utsname uts;
    struct statvfs stat;
    double storage_used = 0.0;

    /* TODO 1: uname() システムコールを呼び出し、uts 構造体にシステム情報を取得せよ */
    (void)uts;

    /* TODO 2: statvfs(".") システムコールを呼び出し、カレントディスクの容量情報を取得せよ
     * f_blocks, f_bavail, f_frsize から使用率（%）を計算し storage_used に代入せよ
     */
    (void)stat;
    (void)storage_used;

    SAO_PRINT_HEADER("RUBY PALACE - FINAL CLEAR");

    /* TODO 3: 仕様に従い OS情報、STORAGE情報、区切り線、クリア認定証を出力せよ
     * OS      : <sysname> (<machine>)
     * STORAGE : <storage_used>% USED
     * --------------------------------------------------
     *       /\
     *      /  \       SWORD ART ONLINE : KERNEL
     *     / /\ \      =========================
     *    / /  \ \     CLEAR CERTIFICATE
     *   / /____\ \
     *  / ________ \   PLAYER : KIRITO
     * / /        \ \  RANK   : S [MASTER OF KERNEL]
     */

    SAO_PRINT_FOOTER();

    /* TODO 4: 正常終了コード（0）を返せ */
    return 1;
}
