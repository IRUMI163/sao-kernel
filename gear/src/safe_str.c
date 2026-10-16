#include <string.h>
#include "safe_str.h"

int safe_str_copy(char *dest, size_t dest_size, const char *src) {
    if (!dest || !src || dest_size == 0) {
        return -1;
    }

    size_t src_len = strlen(src);
    if (src_len < dest_size) {
        memcpy(dest, src, src_len + 1);
        return 0;
    } else {
        memcpy(dest, src, dest_size - 1);
        dest[dest_size - 1] = '\0';
        return 1;
    }
}

int safe_path_join(char *dest, size_t dest_size, const char *dir, const char *file) {
    if (!dest || !dir || !file || dest_size == 0) {
        return -1;
    }

    size_t dir_len = strlen(dir);
    size_t file_len = strlen(file);
    int has_slash = (dir_len > 0 && dir[dir_len - 1] == '/');

    size_t needed = dir_len + (has_slash ? 0 : 1) + file_len + 1;
    if (needed > dest_size) {
        return -1;
    }

    memcpy(dest, dir, dir_len);
    size_t pos = dir_len;
    if (!has_slash) {
        dest[pos++] = '/';
    }
    memcpy(dest + pos, file, file_len);
    pos += file_len;
    dest[pos] = '\0';

    return 0;
}
