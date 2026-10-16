#ifndef GEAR_H
#define GEAR_H

#include "config.h"
#include "safe_str.h"
#include "file_list.h"

#define GEAR_VERSION "1.0.0-aincrad"

int cmd_stat_run(const GearConfig *config);
int cmd_memo_run(const GearConfig *config);
int cmd_clean_run(const GearConfig *config);

#endif /* GEAR_H */
