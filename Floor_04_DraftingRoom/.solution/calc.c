#include "calc.h"

int calc_storage_percent(long used, long total) {
    if (total <= 0) {
        return -1;
    }
    return (int)((used * 100) / total);
}

int calc_player_rank(int score) {
    if (score >= 1000) {
        return 3;
    } else if (score >= 500) {
        return 2;
    } else if (score >= 100) {
        return 1;
    } else {
        return 0;
    }
}
