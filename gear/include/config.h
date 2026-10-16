#ifndef GEAR_CONFIG_H
#define GEAR_CONFIG_H

#include <stdbool.h>
#include <stddef.h>

#define MAX_PATH_LEN 1024
#define MAX_MEMO_LEN 512

typedef enum {
    CMD_NONE = 0,
    CMD_HELP,
    CMD_VERSION,
    CMD_STAT,
    CMD_MEMO,
    CMD_CLEAN
} GearCommand;

typedef struct {
    GearCommand command;
    char target_path[MAX_PATH_LEN];
    char memo_text[MAX_MEMO_LEN];
    bool dry_run;
    bool verbose;
} GearConfig;

int parse_args(int argc, char *argv[], GearConfig *out_config);

#endif /* GEAR_CONFIG_H */
