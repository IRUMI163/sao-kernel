#include <stdio.h>
#include "../shared/sao_ui.h"

int main(void) {
    /* -------------------------------------------------------------------------
     * 【初期データ：プレイヤーのパラメータ（箱）】
     * ------------------------------------------------------------------------- */
    const char *player_name = "KIRITO";   /* プレイヤー名（文字列） */
    int level = 1;                        /* レベル（整数） */
    int hp_current = 250;                 /* 現在HP（整数） */
    int hp_max = 250;                     /* 最大HP（整数） */
    double storage_used = 42.5;           /* ストレージ使用率（小数） */

    /* アインクラッドのウィンドウ枠線（上）を表示 */
    SAO_PRINT_HEADER("STATUS WINDOW");

    /* =========================================================================
     * 【第1層 実装ミッション：ステータス画面を表示せよ！】
     * 
     * MISSION.md の手引きを参考に、printf 関数で4行のステータスを出力せよ。
     * 
     * 【1行目のお手本】
     *   printf("PLAYER : %s\n", player_name);
     *   ↑ %s の場所に player_name がスポッと代入され、最後に \n で改行される！
     * 
     * 【君が書くべき残り3行のヒント】
     *   2行目: printf("LEVEL  : %04d\n", level);
     *   3行目: printf("HP     : %04d / %04d\n", hp_current, hp_max);
     *   4行目: printf("STORAGE: %.1f%% USED\n", storage_used);
     * 
     * ※ 自分の printf を書いたら、下にある (void)... の5行は消して構わないぞ。
     * ========================================================================= */
    (void)player_name;
    (void)level;
    (void)hp_current;
    (void)hp_max;
    (void)storage_used;

    /* アインクラッドのウィンドウ枠線（下）を表示 */
    SAO_PRINT_FOOTER();

    /* TODO: 正常終了（成功）を示す終了コード「0」に変更せよ！（現在は失敗を示す「1」） */
    return 1;
}
