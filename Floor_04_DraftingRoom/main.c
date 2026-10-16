#include <stdio.h>
#include "calc.h"

int main(void) {
    long used = 425;
    long total = 1000;
    int score = 750;

    int storage_pct = calc_storage_percent(used, total);
    int rank = calc_player_rank(score);

    printf("==================================================\n");
    printf("  [AINCRAD SYSTEM] : DRAFTING ROOM MODULE\n");
    printf("==================================================\n");
    printf("STORAGE USAGE : %d%%\n", storage_pct);
    printf("PLAYER SCORE  : %d (RANK: %d)\n", score, rank);
    printf("==================================================\n");

    return 0;
}
