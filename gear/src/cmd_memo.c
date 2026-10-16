#define _POSIX_C_SOURCE 200809L
#include "gear.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int cmd_memo_run(const GearConfig *config) {
    if (!config) {
        return 1;
    }

    const char *memo_path = getenv("GEAR_MEMO_PATH");
    if (!memo_path || memo_path[0] == '\0') {
        memo_path = "./.gear_memo.log";
    }

    FILE *fp = fopen(memo_path, "a");
    if (!fp) {
        perror("Error opening memo log file");
        return 1;
    }

    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);

    struct tm tm_buf;
    localtime_r(&ts.tv_sec, &tm_buf);

    int ms = (int)(ts.tv_nsec / 1000000);

    fprintf(fp, "[%04d-%02d-%02d %02d:%02d:%02d.%03d] %s\n",
            tm_buf.tm_year + 1900,
            tm_buf.tm_mon + 1,
            tm_buf.tm_mday,
            tm_buf.tm_hour,
            tm_buf.tm_min,
            tm_buf.tm_sec,
            ms,
            config->memo_text);

    fclose(fp);

    printf("[MEMO RECORDED] -> %s\n", memo_path);

    return 0;
}
