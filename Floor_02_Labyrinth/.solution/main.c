#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
    /* 1. 引数が存在しない場合 */
    if (argc < 2) {
        printf("[ERROR] NO COMMAND SPECIFIED\n");
        return 1;
    }

    /* 2. -h オプション */
    if (strcmp(argv[1], "-h") == 0) {
        printf("USAGE: gear <stat|memo|clean> [options]\n");
        return 0;
    }

    /* 3. -v オプション */
    if (strcmp(argv[1], "-v") == 0) {
        printf("GEAR VERSION 1.0.0-aincrad\n");
        return 0;
    }

    /* 4. memo コマンド */
    if (strcmp(argv[1], "memo") == 0) {
        if (argc < 3) {
            printf("[ERROR] EMPTY MEMO\n");
            return 1;
        }

        printf("MEMO: ");
        for (int i = 2; i < argc; i++) {
            printf("%s", argv[i]);
            if (i < argc - 1) {
                printf(" ");
            }
        }
        printf("\n");
        return 0;
    }

    /* 5. 未知のコマンド */
    printf("[ERROR] UNKNOWN COMMAND: %s\n", argv[1]);
    return 1;
}
