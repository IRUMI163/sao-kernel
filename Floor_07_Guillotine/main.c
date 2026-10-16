#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "file_list.h"

int main(void) {
    FileList list;
    size_t initial_cap = 4;

    if (init_file_list(&list, initial_cap) != 0) {
        fprintf(stderr, "Error: init_file_list failed\n");
        return 1;
    }

    if (list.count != 0 || list.capacity != initial_cap || list.items == NULL) {
        fprintf(stderr, "Error: Invalid initial state\n");
        free_file_list(&list);
        return 1;
    }

    const size_t total_files = 1000;
    for (size_t i = 0; i < total_files; i++) {
        char name_buf[64];
        snprintf(name_buf, sizeof(name_buf), "file_%04zu.dat", i);

        if (add_file_item(&list, name_buf, "dat", (i + 1) * 100) != 0) {
            fprintf(stderr, "Error: add_file_item failed at index %zu\n", i);
            free_file_list(&list);
            return 1;
        }
    }

    if (list.count != total_files) {
        fprintf(stderr, "Error: Expected count %zu, got %zu\n", total_files, list.count);
        free_file_list(&list);
        return 1;
    }

    if (list.capacity < total_files) {
        fprintf(stderr, "Error: Expected capacity >= %zu, got %zu\n", total_files, list.capacity);
        free_file_list(&list);
        return 1;
    }

    // Check first, middle, and last item
    if (strcmp(list.items[0].filename, "file_0000.dat") != 0 || list.items[0].size_bytes != 100) {
        fprintf(stderr, "Error: First item mismatch\n");
        free_file_list(&list);
        return 1;
    }

    if (strcmp(list.items[499].filename, "file_0499.dat") != 0 || list.items[499].size_bytes != 50000) {
        fprintf(stderr, "Error: Middle item mismatch\n");
        free_file_list(&list);
        return 1;
    }

    if (strcmp(list.items[999].filename, "file_0999.dat") != 0 || list.items[999].size_bytes != 100000) {
        fprintf(stderr, "Error: Last item mismatch\n");
        free_file_list(&list);
        return 1;
    }

    printf("Successfully added %zu files. Dynamic array capacity expanded to %zu.\n", list.count, list.capacity);

    free_file_list(&list);

    if (list.items != NULL || list.count != 0 || list.capacity != 0) {
        fprintf(stderr, "Error: List state not properly reset after free_file_list\n");
        return 1;
    }

    return 0;
}
