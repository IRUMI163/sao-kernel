#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"

static int run_tests(void) {
    GearConfig config;
    int res;

    /* Pattern 1: Invalid Arguments (argc < 2 or NULL out_config) */
    char *argv1[] = {"gear"};
    res = parse_args(1, argv1, &config);
    if (res != -1) {
        printf("[FAIL] Pattern 1: Expected -1 for argc < 2, got %d\n", res);
        return 1;
    }
    res = parse_args(2, argv1, NULL);
    if (res != -1) {
        printf("[FAIL] Pattern 1: Expected -1 for NULL out_config, got %d\n", res);
        return 1;
    }

    /* Pattern 2: Help / Version (-h or --version) */
    char *argv2[] = {"gear", "-h"};
    res = parse_args(2, argv2, &config);
    if (res != 0 || config.command != CMD_HELP || strcmp(config.target_path, "./dungeon_box") != 0) {
        printf("[FAIL] Pattern 2: Failed to parse '-h'\n");
        return 1;
    }

    char *argv2_v[] = {"gear", "--version"};
    res = parse_args(2, argv2_v, &config);
    if (res != 0 || config.command != CMD_VERSION) {
        printf("[FAIL] Pattern 2: Failed to parse '--version'\n");
        return 1;
    }

    /* Pattern 3: Stat command ("stat") */
    char *argv3[] = {"gear", "stat"};
    res = parse_args(2, argv3, &config);
    if (res != 0 || config.command != CMD_STAT || strcmp(config.target_path, "./dungeon_box") != 0 ||
        config.dry_run != false || config.verbose != false) {
        printf("[FAIL] Pattern 3: Failed to parse 'stat'\n");
        return 1;
    }

    /* Pattern 4: Memo command ("memo <text>") and error case */
    char *argv4_err[] = {"gear", "memo"};
    res = parse_args(2, argv4_err, &config);
    if (res != -1) {
        printf("[FAIL] Pattern 4: Expected -1 for memo without text, got %d\n", res);
        return 1;
    }

    char *argv4[] = {"gear", "memo", "System Alert: Boss Spawned"};
    res = parse_args(3, argv4, &config);
    if (res != 0 || config.command != CMD_MEMO || strcmp(config.memo_text, "System Alert: Boss Spawned") != 0) {
        printf("[FAIL] Pattern 4: Failed to parse 'memo'\n");
        return 1;
    }

    /* Pattern 5: Clean command with options ("clean --dry-run -v /custom/dir") */
    char *argv5[] = {"gear", "clean", "--dry-run", "-v", "/custom/dir"};
    res = parse_args(5, argv5, &config);
    if (res != 0 || config.command != CMD_CLEAN || strcmp(config.target_path, "/custom/dir") != 0 ||
        config.dry_run != true || config.verbose != true) {
        printf("[FAIL] Pattern 5: Failed to parse 'clean' with options\n");
        return 1;
    }

    /* Pattern 6: Invalid / Unknown Subcommand */
    char *argv6[] = {"gear", "unknown_cmd"};
    res = parse_args(2, argv6, &config);
    if (res != -1) {
        printf("[FAIL] Pattern 6: Expected -1 for unknown subcommand, got %d\n", res);
        return 1;
    }

    printf("ALL_PATTERNS_PASSED\n");
    return 0;
}

int main(void) {
    return run_tests();
}
