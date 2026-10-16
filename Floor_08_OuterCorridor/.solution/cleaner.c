#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

/* Helper function to determine category based on file extension */
static const char *get_category(const char *filename) {
    const char *ext = strrchr(filename, '.');
    if (ext == NULL || ext == filename) {
        return "Others";
    }

    if (strcmp(ext, ".png") == 0 || strcmp(ext, ".jpg") == 0) {
        return "Images";
    } else if (strcmp(ext, ".pdf") == 0 || strcmp(ext, ".txt") == 0) {
        return "Docs";
    } else if (strcmp(ext, ".c") == 0 || strcmp(ext, ".h") == 0) {
        return "Code";
    } else if (strcmp(ext, ".zip") == 0) {
        return "Archives";
    } else {
        return "Others";
    }
}

int clean_directory(const char *target_dir, int dry_run) {
    if (target_dir == NULL) {
        return -1;
    }

    DIR *dir = opendir(target_dir);
    if (dir == NULL) {
        perror("opendir failed");
        return -1;
    }

    struct dirent *entry;
    int moved_count = 0;

    while ((entry = readdir(dir)) != NULL) {
        // Skip hidden files starting with '.' (including '.' and '..')
        if (entry->d_name[0] == '.') {
            continue;
        }

        // Build full path to the file
        char old_path[1024];
        snprintf(old_path, sizeof(old_path), "%s/%s", target_dir, entry->d_name);

        // Get file info using stat
        struct stat st;
        if (stat(old_path, &st) != 0) {
            continue;
        }

        // Skip subdirectories
        if (S_ISDIR(st.st_mode)) {
            continue;
        }

        // Determine category folder name
        const char *category = get_category(entry->d_name);

        // Build target subdirectory path and new file path
        char dest_dir[1024];
        char new_path[1024];
        snprintf(dest_dir, sizeof(dest_dir), "%s/%s", target_dir, category);
        snprintf(new_path, sizeof(new_path), "%s/%s/%s", target_dir, category, entry->d_name);

        if (dry_run == 0) {
            // Create target directory if it doesn't exist
            mkdir(dest_dir, 0755);

            // Move file using rename
            if (rename(old_path, new_path) == 0) {
                moved_count++;
            }
        } else {
            // Dry run mode: just count
            moved_count++;
        }
    }

    closedir(dir);
    return moved_count;
}
