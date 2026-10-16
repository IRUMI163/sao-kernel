#include "config.h"
#include "safe_str.h"
#include <string.h>
#include <stdio.h>

int parse_args(int argc, char *argv[], GearConfig *out_config) {
    if (!out_config) {
        return -1;
    }

    memset(out_config, 0, sizeof(GearConfig));
    out_config->command = CMD_NONE;

    if (argc <= 1) {
        out_config->command = CMD_HELP;
        return 0;
    }

    int i = 1;
    while (i < argc) {
        const char *arg = argv[i];

        if (strcmp(arg, "-h") == 0 || strcmp(arg, "--help") == 0) {
            out_config->command = CMD_HELP;
            return 0;
        } else if (strcmp(arg, "-v") == 0 || strcmp(arg, "--version") == 0) {
            out_config->command = CMD_VERSION;
            return 0;
        } else if (strcmp(arg, "--dry-run") == 0) {
            out_config->dry_run = true;
        } else if (strcmp(arg, "--verbose") == 0 || strcmp(arg, "-v") == 0) {
            out_config->verbose = true;
        } else if (strcmp(arg, "stat") == 0) {
            if (out_config->command == CMD_NONE) {
                out_config->command = CMD_STAT;
            }
        } else if (strcmp(arg, "memo") == 0) {
            if (out_config->command == CMD_NONE) {
                out_config->command = CMD_MEMO;
            }
            if (i + 1 < argc && argv[i + 1][0] != '-') {
                i++;
                if (safe_str_copy(out_config->memo_text, sizeof(out_config->memo_text), argv[i]) != 0) {
                    fprintf(stderr, "Error: Memo text too long.\n");
                    return -1;
                }
            } else if (out_config->memo_text[0] == '\0') {
                fprintf(stderr, "Error: 'memo' command requires a message.\n");
                return -1;
            }
        } else if (strcmp(arg, "clean") == 0) {
            if (out_config->command == CMD_NONE) {
                out_config->command = CMD_CLEAN;
            }
        } else {
            if (out_config->command == CMD_CLEAN && out_config->target_path[0] == '\0' && arg[0] != '-') {
                if (safe_str_copy(out_config->target_path, sizeof(out_config->target_path), arg) != 0) {
                    fprintf(stderr, "Error: Target path too long.\n");
                    return -1;
                }
            } else if (out_config->command == CMD_NONE && arg[0] != '-') {
                fprintf(stderr, "Error: Unknown command or argument '%s'\n", arg);
                return -1;
            }
        }
        i++;
    }

    if (out_config->command == CMD_CLEAN && out_config->target_path[0] == '\0') {
        if (safe_str_copy(out_config->target_path, sizeof(out_config->target_path), "./dungeon_box") != 0) {
            return -1;
        }
    }

    if (out_config->command == CMD_MEMO && out_config->memo_text[0] == '\0') {
        fprintf(stderr, "Error: 'memo' command requires a message.\n");
        return -1;
    }

    return 0;
}
