#include "file_list.h"
#include "safe_str.h"
#include <stdlib.h>
#include <string.h>

int init_file_list(FileList *list, size_t initial_capacity) {
    if (!list) {
        return -1;
    }
    size_t cap = (initial_capacity > 0) ? initial_capacity : 8;
    list->items = malloc(cap * sizeof(FileItem));
    if (!list->items) {
        return -1;
    }
    list->count = 0;
    list->capacity = cap;
    return 0;
}

int add_file_item(FileList *list, const char *filename, const char *ext, size_t size_bytes) {
    if (!list || !filename) {
        return -1;
    }
    if (list->count >= list->capacity) {
        size_t new_cap = (list->capacity == 0) ? 8 : list->capacity * 2;
        FileItem *new_items = realloc(list->items, new_cap * sizeof(FileItem));
        if (!new_items) {
            return -1;
        }
        list->items = new_items;
        list->capacity = new_cap;
    }

    size_t name_len = strlen(filename);
    char *dup_name = malloc(name_len + 1);
    if (!dup_name) {
        return -1;
    }
    memcpy(dup_name, filename, name_len + 1);

    list->items[list->count].filename = dup_name;
    if (safe_str_copy(list->items[list->count].extension, sizeof(list->items[list->count].extension), ext ? ext : "") != 0) {
        free(dup_name);
        return -1;
    }
    list->items[list->count].size_bytes = size_bytes;
    list->count++;

    return 0;
}

void free_file_list(FileList *list) {
    if (!list) {
        return;
    }
    if (list->items) {
        for (size_t i = 0; i < list->count; i++) {
            free(list->items[i].filename);
        }
        free(list->items);
        list->items = NULL;
    }
    list->count = 0;
    list->capacity = 0;
}
