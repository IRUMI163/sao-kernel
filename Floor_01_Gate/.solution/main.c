#include <stdio.h>
#include "../../shared/sao_ui.h"

int main(void) {
    const char *player_name = "KIRITO";
    int level = 1;
    int hp_current = 250;
    int hp_max = 250;
    double storage_used = 42.5;

    SAO_PRINT_HEADER("STATUS WINDOW");

    printf("PLAYER : %s\n", player_name);
    printf("LEVEL  : %04d\n", level);
    printf("HP     : %04d / %04d\n", hp_current, hp_max);
    printf("STORAGE: %.1f%% USED\n", storage_used);

    SAO_PRINT_FOOTER();

    return 0;
}
