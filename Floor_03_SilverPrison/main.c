#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "safe_str.h"

int main(void) {
    char buf[16];
    int res;

    printf("[TEST] Testing safe_str_copy...\n");

    // 1. NULL parameter checks
    assert(safe_str_copy(NULL, 10, "test") == -1);
    assert(safe_str_copy(buf, 10, NULL) == -1);
    assert(safe_str_copy(buf, 0, "test") == -1);

    // 2. Normal copy (exact fit or smaller)
    memset(buf, 'X', sizeof(buf));
    res = safe_str_copy(buf, 10, "hello");
    assert(res == 0);
    assert(strcmp(buf, "hello") == 0);

    // 3. Truncation copy
    memset(buf, 'X', sizeof(buf));
    res = safe_str_copy(buf, 5, "hello world");
    assert(res == 1);
    assert(strcmp(buf, "hell") == 0);
    assert(buf[4] == '\0');

    // 4. Boundary cases (dest_size == strlen(src) + 1 vs dest_size == strlen(src))
    memset(buf, 'X', sizeof(buf));
    res = safe_str_copy(buf, 6, "hello");
    assert(res == 0);
    assert(strcmp(buf, "hello") == 0);

    memset(buf, 'X', sizeof(buf));
    res = safe_str_copy(buf, 5, "hello");
    assert(res == 1);
    assert(strcmp(buf, "hell") == 0);

    printf("[TEST] safe_str_copy passed.\n");

    printf("[TEST] Testing safe_path_join...\n");

    // 1. NULL parameter checks
    assert(safe_path_join(NULL, 10, "dir", "file") == -1);
    assert(safe_path_join(buf, 10, NULL, "file") == -1);
    assert(safe_path_join(buf, 10, "dir", NULL) == -1);
    assert(safe_path_join(buf, 0, "dir", "file") == -1);

    // 2. Join without trailing slash in dir
    memset(buf, 'X', sizeof(buf));
    res = safe_path_join(buf, sizeof(buf), "/usr/local", "bin");
    assert(res == 0);
    assert(strcmp(buf, "/usr/local/bin") == 0);

    // 3. Join with trailing slash in dir
    memset(buf, 'X', sizeof(buf));
    res = safe_path_join(buf, sizeof(buf), "/usr/local/", "bin");
    assert(res == 0);
    assert(strcmp(buf, "/usr/local/bin") == 0);

    // 4. Buffer size insufficient
    // "/usr/local/bin" requires 15 bytes including null terminator
    memset(buf, 'X', sizeof(buf));
    res = safe_path_join(buf, 14, "/usr/local", "bin");
    assert(res == -1);

    memset(buf, 'X', sizeof(buf));
    res = safe_path_join(buf, 15, "/usr/local", "bin");
    assert(res == 0);
    assert(strcmp(buf, "/usr/local/bin") == 0);

    printf("[TEST] safe_path_join passed.\n");

    printf("ALL TESTS PASSED SUCCESSFULLY.\n");
    return 0;
}
