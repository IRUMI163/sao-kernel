#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "file_list.h"

int init_file_list(FileList *list, size_t initial_capacity) {
    if (list == NULL || initial_capacity == 0) {
        return -1;
    }

    list->items = (FileItem *)malloc(sizeof(FileItem) * initial_capacity);
    if (list->items == NULL) {
        return -1;
    }

    list->count = 0;
    list->capacity = initial_capacity;
    return 0;
}

int add_file_item(FileList *list, const char *filename, const char *ext, size_t size_bytes) {
    if (list == NULL || list->items == NULL || filename == NULL || ext == NULL) {
        return -1;
    }

    if (list->count >= list->capacity) {
        size_t new_capacity = list->capacity * 2;
        FileItem *new_items = (FileItem *)realloc(list->items, sizeof(FileItem) * new_capacity);
        if (new_items == NULL) {
            return -1;
        }
        list->items = new_items;
        list->capacity = new_capacity;
    }

    FileItem *item = &list->items[list->count];

    item->filename = (char *)malloc(strlen(filename) + 1);
    if (item->filename == NULL) {
        return -1;
    }
    strcpy(item->filename, filename);

    strncpy(item->extension, ext, sizeof(item->extension) - 1);
    item->extension[sizeof(item->extension) - 1] = '\0';

    item->size_bytes = size_bytes;

    list->count++;
    return 0;
}

void free_file_list(FileList *list) {
    if (list == NULL) {
        return;
    }

    if (list->items != NULL) {
        for (size_t i = 0; i < list->count; i++) {
            if (list->items[i].filename != NULL) {
                free(list->items[i].filename);
                list->items[i].filename = NULL;
            }
        }
        free(list->items);
        list->items = NULL;
    }

    list->count = 0;
    list->capacity = 0;
}
