#include "gear.h"
#include "../../shared/sao_ui.h"
#include <stdio.h>
#include <stdlib.h>
#include <sys/utsname.h>
#include <sys/statvfs.h>

int cmd_stat_run(const GearConfig *config) {
    (void)config;

    const char *user = getenv("USER");
    if (!user || user[0] == '\0') {
        user = "UNKNOWN_PLAYER";
    }

    struct utsname uts;
    if (uname(&uts) != 0) {
        perror("uname failed");
        return 1;
    }

    struct statvfs vfs;
    if (statvfs(".", &vfs) != 0) {
        perror("statvfs failed");
        return 1;
    }

    unsigned long long total_bytes = (unsigned long long)vfs.f_blocks * vfs.f_frsize;
    unsigned long long free_bytes = (unsigned long long)vfs.f_bfree * vfs.f_frsize;
    unsigned long long used_bytes = total_bytes - free_bytes;

    double used_pct = 0.0;
    if (total_bytes > 0) {
        used_pct = ((double)used_bytes / (double)total_bytes) * 100.0;
    }

    int total_blocks = 10;
    int filled_blocks = (int)((used_pct / 100.0) * total_blocks + 0.5);
    if (filled_blocks > total_blocks) filled_blocks = total_blocks;
    if (filled_blocks < 0) filled_blocks = 0;

    char bar_str[128] = {0};
    int pos = 0;
    bar_str[pos++] = '[';
    for (int i = 0; i < filled_blocks; i++) {
        /* "█" is UTF-8 bytes 0xE2, 0x96, 0x88 */
        bar_str[pos++] = (char)0xE2;
        bar_str[pos++] = (char)0x96;
        bar_str[pos++] = (char)0x88;
    }
    for (int i = filled_blocks; i < total_blocks; i++) {
        /* "░" is UTF-8 bytes 0xE2, 0x96, 0x91 */
        bar_str[pos++] = (char)0xE2;
        bar_str[pos++] = (char)0x96;
        bar_str[pos++] = (char)0x91;
    }
    bar_str[pos++] = ']';
    bar_str[pos] = '\0';

    SAO_PRINT_HEADER("PLAYER & SYSTEM STATS");
    printf(" PLAYER NAME : %s\n", user);
    printf(" OS SYSTEM   : %s %s\n", uts.sysname, uts.release);
    printf(" ARCHITECTURE: %s\n", uts.machine);
    printf(" STORAGE USAGE: %s %.1f%%\n", bar_str, used_pct);
    SAO_PRINT_FOOTER();

    return 0;
}
