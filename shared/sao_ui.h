#ifndef SAO_UI_H
#define SAO_UI_H

#include <stdio.h>

/* ANSI Color Codes */
#define SAO_CLR_RESET   "\033[0m"
#define SAO_CLR_CYAN    "\033[1;36m"
#define SAO_CLR_GREEN   "\033[1;32m"
#define SAO_CLR_YELLOW  "\033[1;33m"
#define SAO_CLR_RED     "\033[1;31m"
#define SAO_CLR_MAGENTA "\033[1;35m"

/* SAO System Banner Macros */
#define SAO_PRINT_HEADER(title) \
    do { \
        printf("==================================================\n"); \
        printf("  [AINCRAD SYSTEM] : %s\n", (title)); \
        printf("==================================================\n"); \
    } while (0)

#define SAO_PRINT_FOOTER() \
    do { \
        printf("==================================================\n"); \
    } while (0)

#endif /* SAO_UI_H */
