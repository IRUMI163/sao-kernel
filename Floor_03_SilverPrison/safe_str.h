#ifndef GEAR_SAFE_STR_H
#define GEAR_SAFE_STR_H

#include <stddef.h>

int safe_str_copy(char *dest, size_t dest_size, const char *src);
int safe_path_join(char *dest, size_t dest_size, const char *dir, const char *file);

#endif /* GEAR_SAFE_STR_H */
