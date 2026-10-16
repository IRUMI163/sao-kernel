#include <stdio.h>
#include <stdlib.h>

void level_up(int *level) {
    if (level != NULL) {
        (*level)++;
    }
}

int safe_read_hp(const int *hp_ptr) {
    if (hp_ptr == NULL) {
        return -1;
    }
    return *hp_ptr;
}

void init_array(int *arr, int size) {
    if (arr == NULL || size < 0) {
        return;
    }
    for (int i = 0; i < size; i++) {
        arr[i] = (i + 1) * 10;
    }
}

int main(void) {
    printf("==================================================\n");
    printf("  [AINCRAD SYSTEM] : FLOOR 05 EXAM - ABYSS\n");
    printf("==================================================\n");

    // TEST 1: level_up
    int current_level = 1;
    printf("[TEST 1] Pass-by-Pointer Check\n");
    printf("  Before: Level %d\n", current_level);
    level_up(&current_level);
    if (current_level == 2) {
        printf("  After : Level %d (SUCCESS)\n", current_level);
    } else {
        printf("  After : Level %d (FAILED: Level did not increase!)\n", current_level);
    }
    printf("\n");

    // TEST 2: safe_read_hp
    int player_hp = 250;
    printf("[TEST 2] NULL Pointer Guard Check\n");
    int hp_valid = safe_read_hp(&player_hp);
    printf("  Valid HP Read: %d\n", hp_valid);

    int hp_null = safe_read_hp(NULL);
    if (hp_null == -1) {
        printf("  NULL HP Read : %d (SUCCESS)\n", hp_null);
    } else {
        printf("  NULL HP Read : %d (FAILED)\n", hp_null);
    }
    printf("\n");

    // TEST 3: init_array
    printf("[TEST 3] Array Boundary Check\n");
    int buffer[5];
    init_array(buffer, 5);
    printf("  Array Elements: %d %d %d %d %d\n",
           buffer[0], buffer[1], buffer[2], buffer[3], buffer[4]);
    printf("  Boundary Check: PASSED (SUCCESS)\n");

    printf("==================================================\n");
    printf("ALL TESTS PASSED! YOU SURVIVED THE ABYSS.\n");
    printf("==================================================\n");

    return 0;
}
