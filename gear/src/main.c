#include "gear.h"
#include "../../shared/sao_ui.h"
#include <stdio.h>

static void print_help(void) {
    SAO_PRINT_HEADER("GEAR CLI TOOL - HELP");
    printf(" Usage: gear <command> [options]\n\n");
    printf(" Commands:\n");
    printf("   stat                  Display system and player stats with SAO UI\n");
    printf("   memo <text>           Append timestamped memo to log file\n");
    printf("   clean [target_dir]    Organize files in directory by extensions\n");
    printf("\n Options:\n");
    printf("   -h, --help            Show this help message\n");
    printf("   -v, --version         Show version information\n");
    printf("   --dry-run             Simulate file organization without moving files\n");
    printf("   --verbose             Enable verbose output\n");
    SAO_PRINT_FOOTER();
}

static void print_version(void) {
    printf("gear version %s\n", GEAR_VERSION);
}

int main(int argc, char *argv[]) {
    GearConfig config;
    if (parse_args(argc, argv, &config) != 0) {
        return 1;
    }

    switch (config.command) {
        case CMD_HELP:
            print_help();
            return 0;
        case CMD_VERSION:
            print_version();
            return 0;
        case CMD_STAT:
            return cmd_stat_run(&config);
        case CMD_MEMO:
            return cmd_memo_run(&config);
        case CMD_CLEAN:
            return cmd_clean_run(&config);
        case CMD_NONE:
        default:
            print_help();
            return 0;
    }
}
