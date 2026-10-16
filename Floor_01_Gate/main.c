#include <stdio.h>
#include "../shared/sao_ui.h"

int main(void) {
    const char *player_name = "KIRITO";
    int level = 1;
    int hp_current = 250;
    int hp_max = 250;
    double storage_used = 42.5;

    SAO_PRINT_HEADER("STATUS WINDOW");

    /* =========================================================================
     * 【第1層 実装ミッション：ステータスウィンドウの出力】
     * MISSION.md の手引きを参考に、printf 関数で4行のステータスを表示せよ。
     * 
     * 【書き方のお手本（1行目: プレイヤー名）】
     *   printf("PLAYER : %s\n", player_name);
     *   ↑ %s の場所にカンマ後ろの player_name が代入され、最後に \n で改行される！
     * 
     * 【君が書くべき残り3行のヒント】
     *   2. LEVEL  : 0001        ➔ 整数 level を %04d で4桁ゼロ埋めして表示
     *   3. HP     : 0250 / 0250 ➔ hp_current と hp_max の2つを %04d でスラッシュ挟み
     *   4. STORAGE: 42.5% USED  ➔ storage_used を %.1f%% で小数第1位＋%表示
     * 
     * ※ 自分で printf を書き加えたら、下にある (void)... の行は消して構わないぞ。
     * ========================================================================= */
    (void)player_name;
    (void)level;
    (void)hp_current;
    (void)hp_max;
    (void)storage_used;

    SAO_PRINT_FOOTER();

    /* TODO: 正常終了（成功）を示す終了コード（0）に変更せよ（現在は失敗コード 1） */
    return 1;
}
