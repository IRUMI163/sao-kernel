#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

/*
 * 【ミッション】
 * target_dir 内を走査し、拡張子に応じてファイルを各サブフォルダ（Images, Docs, Code, Archives, Others）へ分類・移動せよ。
 *
 * 仕様:
 * 1. target_dir 内のエントリを opendir / readdir で走査する。
 * 2. ドット '.' で始まる隠しファイル（例: .hidden_key）やディレクトリ参照 (., ..) はスキップする。
 * 3. サブディレクトリ自体 (stat で S_ISDIR に該当するもの) はスキップする。
 * 4. 拡張子に応じて移動先サブディレクトリを特定する:
 *    - ".png", ".jpg" ➔ "Images"
 *    - ".pdf", ".txt" ➔ "Docs"
 *    - ".c", ".h"     ➔ "Code"
 *    - ".zip"         ➔ "Archives"
 *    - その他         ➔ "Others"
 * 5. dry_run == 0 の場合:
 *    - 移動先ディレクトリが存在しなければ mkdir(subfolder_path, 0755) で作成する。
 *    - rename(old_path, new_path) でファイルを移動する。
 * 6. 移動（または移動予定）となった件数をカウントして返す。
 */

int clean_directory(const char *target_dir, int dry_run) {
    (void)target_dir;
    (void)dry_run;

    /* TODO: opendir, readdir, stat, rename 等を用いてディレクトリクリーン処理を実装せよ */

    return -1;
}
