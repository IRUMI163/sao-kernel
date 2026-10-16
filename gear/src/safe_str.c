#include "safe_str.h"
#include <string.h>
#include <stdbool.h>

int safe_str_copy(char *dest, size_t dest_size, const char *src) {
    if (!dest || dest_size == 0) {
        return -1;
    }
    if (!src) {
        dest[0] = '\0';
        return 0;
    }
    size_t src_len = strlen(src);
    if (src_len >= dest_size) {
        return -1;
    }
    memcpy(dest, src, src_len + 1);
    return 0;
}

int safe_path_join(char *dest, size_t dest_size, const char *dir, const char *file) {
    if (!dest || dest_size == 0 || !dir || !file) {
        return -1;
    }
    size_t dir_len = strlen(dir);
    size_t file_len = strlen(file);
    bool needs_slash = (dir_len > 0 && dir[dir_len - 1] != '/');
    size_t total_len = dir_len + (needs_slash ? 1 : 0) + file_len;

    if (total_len >= dest_size) {
        return -1;
    }

    memcpy(dest, dir, dir_len);
    size_t pos = dir_len;
    if (needs_slash) {
        dest[pos++] = '/';
    }
    memcpy(dest + pos, file, file_len + 1);
    return 0;
}
