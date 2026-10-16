#include <stdio.h>
#include "../shared/sao_ui.h"

int main(void) {
    const char *player_name = "KIRITO";
    int level = 1;
    int hp_current = 250;
    int hp_max = 250;
    double storage_used = 42.5;

    SAO_PRINT_HEADER("STATUS WINDOW");

    /* TODO: MISSION.md の仕様に従い、以下の4項目をフォーマット指定子を使って出力せよ
     * 1. PLAYER : KIRITO         (%s を使用)
     * 2. LEVEL  : 0001           (%04d を使用して4桁ゼロ埋め)
     * 3. HP     : 0250 / 0250    (%04d を2つ使用)
     * 4. STORAGE: 42.5% USED     (%.1f%% を使用して小数第1位＋%記号を表示)
     */
    (void)player_name;
    (void)level;
    (void)hp_current;
    (void)hp_max;
    (void)storage_used;

    SAO_PRINT_FOOTER();

    /* TODO: 正常終了を示す終了コード（0）を返せ */
    return 1;
}
