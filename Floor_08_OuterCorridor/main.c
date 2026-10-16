#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../shared/sao_ui.h"

int clean_directory(const char *target_dir, int dry_run);

int main(int argc, char *argv[]) {
    const char *target_dir = "./dungeon_box";
    int dry_run = 0;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--dry-run") == 0) {
            dry_run = 1;
        } else if (argv[i][0] != '-') {
            target_dir = argv[i];
        }
    }

    SAO_PRINT_HEADER("OUTER CORRIDOR - FILE CLEANER");
    printf("Target Directory: %s\n", target_dir);
    printf("Mode            : %s\n", dry_run ? "DRY-RUN (SIMULATION)" : "EXECUTE (REAL MOVE)");

    int count = clean_directory(target_dir, dry_run);

    if (count < 0) {
        printf("Error: Directory cleaning failed.\n");
        SAO_PRINT_FOOTER();
        return 1;
    }

    printf("Processed Files : %d\n", count);
    SAO_PRINT_FOOTER();

    return 0;
}
