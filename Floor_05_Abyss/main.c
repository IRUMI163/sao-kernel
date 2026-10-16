#include <stdio.h>
#include <stdlib.h>

/*
 * =================================================================
 * [BUG 1] 値渡し（Pass by Value）のバグ
 * 仕様: 呼び出し元のレベル変数を +1 インクリメントしたい。
 * 現状: 値渡しになっているため、呼び出し元のレベルが更新されない。
 * TODO: 引数をポインタ渡し (int *level) に修正し、関数の呼び出し方も修正せよ。
 * =================================================================
 */
void level_up(int level) {
    /* TODO: ポインタ渡しに変更し、指す先を +1 する */
    level++;
}

/*
 * =================================================================
 * [BUG 2] NULL ポインタ参照（SIGSEGV）のバグ
 * 仕様: hp_ptr が NULL の場合は安全に -1 を返し、NULL でない場合は値を返す。
 * 現状: NULL チェックを行わずに *hp_ptr を直接参照してクラッシュする。
 * TODO: hp_ptr が NULL か判定する if文を追加せよ。
 * =================================================================
 */
int safe_read_hp(const int *hp_ptr) {
    /* TODO: NULL チェックを追加せよ */
    return *hp_ptr;
}

/*
 * =================================================================
 * [BUG 3] Off-by-One バッファオーバーフロー（ASan検知）のバグ
 * 仕様: 大きさ size の配列 arr の各要素に (i + 1) * 10 を代入する。
 * 現状: ループ条件が i <= size になっており、配列外にアクセスする。
 * TODO: ループの継続条件を正しく修正せよ。
 * =================================================================
 */
void init_array(int *arr, int size) {
    /* TODO: i <= size のバグを修正せよ */
    for (int i = 0; i <= size; i++) {
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
    /* TODO: 関数の型変更に合わせて引数を渡すように修正すること */
    level_up(current_level);
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
