#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/stat.h>

int main(int argc, char *argv[]) {
    // 1. コマンドライン引数チェック
    if (argc < 2) {
        fprintf(stderr, "[USAGE ERROR] File path required\n");
        return 1;
    }

    const char *filepath = argv[1];
    struct stat st;

    // 2. ディレクトリ判定 (stat & S_ISDIR)
    if (stat(filepath, &st) == 0 && S_ISDIR(st.st_mode)) {
        fprintf(stderr, "[IO ERROR] Target is a directory\n");
        return 2;
    }

    // 3. ファイルオープン & エラー判定 (fopen & strerror(errno))
    FILE *fp = fopen(filepath, "r");
    if (fp == NULL) {
        fprintf(stderr, "[IO ERROR] %s\n", strerror(errno));
        return 2;
    }

    // 4. 行数カウント
    long lines = 0;
    int ch;
    while ((ch = fgetc(fp)) != EOF) {
        if (ch == '\n') {
            lines++;
        }
    }

    fclose(fp);

    // stdout に結果を出力
    printf("LINES: %ld\n", lines);
    return 0;
}
