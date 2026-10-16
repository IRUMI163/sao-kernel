#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
    /* =========================================================================
     * 【第2層 実装ミッション：コマンドライン引数解析ルーター】
     * 
     * MISSION.md の手引きを参考に、以下の5つの条件分岐（if文）を順番に実装せよ。
     * 
     * 【1つ目のお手本：引数なしのガード節】
     *   if (argc < 2) {
     *       printf("[ERROR] NO COMMAND SPECIFIED\n");
     *       return 1;
     *   }
     * 
     * 【2つ目：-h オプションの判定】
     *   if (strcmp(argv[1], "-h") == 0) {
     *       printf("USAGE: gear <stat|memo|clean> [options]\n");
     *       return 0;
     *   }
     * 
     * 【3つ目：-v オプションの判定】
     *   if (strcmp(argv[1], "-v") == 0) { ... "GEAR VERSION 1.0.0-aincrad" を出力し return 0; }
     * 
     * 【4つ目：memo コマンドの判定】
     *   if (strcmp(argv[1], "memo") == 0) {
     *       if (argc == 2) { printf("[ERROR] EMPTY MEMO\n"); return 1; }
     *       printf("MEMO:");
     *       for (int i = 2; i < argc; i++) { printf(" %s", argv[i]); }
     *       printf("\n");
     *       return 0;
     *   }
     * 
     * 【5つ目：未知のコマンドの処理】
     *   printf("[ERROR] UNKNOWN COMMAND: %s\n", argv[1]);
     *   return 1;
     * 
     * ※ 自分のコードを書いたら、下にある (void)... の行は消して構わないぞ。
     * ========================================================================= */
    (void)argc;
    (void)argv;

    return 1;
}
