#ifndef GEAR_FILE_LIST_H
#define GEAR_FILE_LIST_H

#include <stddef.h>

typedef struct {
    char *filename;
    char extension[32];
    size_t size_bytes;
} FileItem;

typedef struct {
    FileItem *items;
    size_t count;
    size_t capacity;
} FileList;

int init_file_list(FileList *list, size_t initial_capacity);
int add_file_item(FileList *list, const char *filename, const char *ext, size_t size_bytes);
void free_file_list(FileList *list);

#endif /* GEAR_FILE_LIST_H */
