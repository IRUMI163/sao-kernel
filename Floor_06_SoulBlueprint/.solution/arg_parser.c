#include "config.h"
#include <string.h>
#include <stdio.h>

int parse_args(int argc, char *argv[], GearConfig *out_config) {
    if (out_config == NULL || argc < 2) {
        return -1;
    }

    memset(out_config, 0, sizeof(GearConfig));
    snprintf(out_config->target_path, sizeof(out_config->target_path), "%s", "./dungeon_box");

    const char *subcmd = argv[1];

    if (strcmp(subcmd, "-h") == 0 || strcmp(subcmd, "--help") == 0) {
        out_config->command = CMD_HELP;
        return 0;
    }

    if (strcmp(subcmd, "-v") == 0 || strcmp(subcmd, "--version") == 0) {
        out_config->command = CMD_VERSION;
        return 0;
    }

    if (strcmp(subcmd, "stat") == 0) {
        out_config->command = CMD_STAT;
        return 0;
    }

    if (strcmp(subcmd, "memo") == 0) {
        out_config->command = CMD_MEMO;
        if (argc < 3 || argv[2][0] == '\0') {
            return -1;
        }
        snprintf(out_config->memo_text, sizeof(out_config->memo_text), "%s", argv[2]);
        return 0;
    }

    if (strcmp(subcmd, "clean") == 0) {
        out_config->command = CMD_CLEAN;
        for (int i = 2; i < argc; i++) {
            if (strcmp(argv[i], "--dry-run") == 0) {
                out_config->dry_run = true;
            } else if (strcmp(argv[i], "--verbose") == 0 || strcmp(argv[i], "-v") == 0) {
                out_config->verbose = true;
            } else {
                snprintf(out_config->target_path, sizeof(out_config->target_path), "%s", argv[i]);
            }
        }
        return 0;
    }

    return -1;
}
