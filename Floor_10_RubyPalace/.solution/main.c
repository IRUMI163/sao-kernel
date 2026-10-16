#include <stdio.h>
#include <sys/utsname.h>
#include <sys/statvfs.h>
#include "../../shared/sao_ui.h"

int main(void) {
    struct utsname uts;
    if (uname(&uts) != 0) {
        return 1;
    }

    struct statvfs stat;
    if (statvfs(".", &stat) != 0) {
        return 1;
    }

    double storage_used = 0.0;
    if (stat.f_blocks > 0) {
        double total_bytes = (double)stat.f_blocks * (double)stat.f_frsize;
        double free_bytes  = (double)stat.f_bavail * (double)stat.f_frsize;
        double used_bytes  = total_bytes - free_bytes;
        storage_used = (used_bytes / total_bytes) * 100.0;
    }

    SAO_PRINT_HEADER("RUBY PALACE - FINAL CLEAR");

    printf("OS      : %s (%s)\n", uts.sysname, uts.machine);
    printf("STORAGE : %.1f%% USED\n", storage_used);
    printf("--------------------------------------------------\n");
    printf("      /\\\n");
    printf("     /  \\       SWORD ART ONLINE : KERNEL\n");
    printf("    / /\\ \\      =========================\n");
    printf("   / /  \\ \\     CLEAR CERTIFICATE\n");
    printf("  / /____\\ \\    \n");
    printf(" / ________ \\   PLAYER : KIRITO\n");
    printf("/ /        \\ \\  RANK   : S [MASTER OF KERNEL]\n");

    SAO_PRINT_FOOTER();

    return 0;
}
