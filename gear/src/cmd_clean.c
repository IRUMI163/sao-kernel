#include "gear.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>

static const char *get_category(const char *ext) {
    if (!ext || ext[0] == '\0') {
        return "Others";
    }

    if (strcasecmp(ext, ".png") == 0 || strcasecmp(ext, ".jpg") == 0 ||
        strcasecmp(ext, ".jpeg") == 0 || strcasecmp(ext, ".gif") == 0) {
        return "Images";
    }

    if (strcasecmp(ext, ".pdf") == 0 || strcasecmp(ext, ".md") == 0 ||
        strcasecmp(ext, ".txt") == 0) {
        return "Docs";
    }

    if (strcasecmp(ext, ".c") == 0 || strcasecmp(ext, ".h") == 0 ||
        strcasecmp(ext, ".sh") == 0 || strcasecmp(ext, ".py") == 0) {
        return "Code";
    }

    if (strcasecmp(ext, ".zip") == 0 || strcasecmp(ext, ".tar") == 0 ||
        strcasecmp(ext, ".gz") == 0 || strcasecmp(ext, ".tgz") == 0) {
        return "Archives";
    }

    return "Others";
}

int cmd_clean_run(const GearConfig *config) {
    if (!config) {
        return 1;
    }

    DIR *dir = opendir(config->target_path);
    if (!dir) {
        fprintf(stderr, "Error: Cannot open directory '%s': %s\n", config->target_path, strerror(errno));
        return 1;
    }

    FileList flist;
    if (init_file_list(&flist, 16) != 0) {
        closedir(dir);
        fprintf(stderr, "Error: Failed to initialize file list\n");
        return 1;
    }

    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }

        char full_path[MAX_PATH_LEN];
        if (safe_path_join(full_path, sizeof(full_path), config->target_path, entry->d_name) != 0) {
            continue;
        }

        struct stat st;
        if (stat(full_path, &st) != 0) {
            continue;
        }

        if (S_ISREG(st.st_mode)) {
            const char *dot = strrchr(entry->d_name, '.');
            const char *ext = dot ? dot : "";
            add_file_item(&flist, entry->d_name, ext, (size_t)st.st_size);
        }
    }
    closedir(dir);

    if (flist.count == 0) {
        if (config->verbose) {
            printf("No regular files to organize in '%s'.\n", config->target_path);
        }
        free_file_list(&flist);
        return 0;
    }

    for (size_t i = 0; i < flist.count; i++) {
        const char *fname = flist.items[i].filename;
        const char *ext = flist.items[i].extension;
        const char *cat = get_category(ext);

        char sub_dir[MAX_PATH_LEN];
        if (safe_path_join(sub_dir, sizeof(sub_dir), config->target_path, cat) != 0) {
            fprintf(stderr, "Error creating path for directory '%s'\n", cat);
            continue;
        }

        if (!config->dry_run) {
            struct stat st_dir;
            if (stat(sub_dir, &st_dir) != 0) {
                if (mkdir(sub_dir, 0755) != 0 && errno != EEXIST) {
                    fprintf(stderr, "Error creating directory '%s': %s\n", sub_dir, strerror(errno));
                    continue;
                }
            }
        }

        char src_path[MAX_PATH_LEN];
        char dst_path[MAX_PATH_LEN];
        if (safe_path_join(src_path, sizeof(src_path), config->target_path, fname) != 0 ||
            safe_path_join(dst_path, sizeof(dst_path), sub_dir, fname) != 0) {
            fprintf(stderr, "Error constructing path for '%s'\n", fname);
            continue;
        }

        if (config->dry_run) {
            printf("[DRY-RUN] Move '%s' -> '%s/'\n", fname, cat);
        } else {
            if (rename(src_path, dst_path) != 0) {
                fprintf(stderr, "Error moving '%s' -> '%s/': %s\n", fname, cat, strerror(errno));
            } else if (config->verbose) {
                printf("[MOVED] '%s' -> '%s/'\n", fname, cat);
            }
        }
    }

    free_file_list(&flist);
    return 0;
}
