#!/bin/bash
# SAO: Kernel - Common Test Helper Library

GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

USE_SOLUTION=0
if [ "$1" = "--solution" ]; then
    USE_SOLUTION=1
fi

sao_banner() {
    local floor_num="$1"
    local floor_title="$2"
    echo -e "${CYAN}==================================================${NC}"
    echo -e "${CYAN}  SWORD ART ONLINE : KERNEL - FLOOR ${floor_num} BOSS TEST${NC}"
    echo -e "${CYAN}  [${floor_title}]${NC}"
    if [ "$USE_SOLUTION" -eq 1 ]; then
        echo -e "${YELLOW}  [MODE: SOLUTION VERIFICATION (.solution)]${NC}"
    fi
    echo -e "${CYAN}==================================================${NC}"
}

sao_pass() {
    local msg="$1"
    echo -e "${GREEN}[PASS]${NC} ${msg}"
}

sao_fail() {
    local msg="$1"
    echo -e "${RED}[FAIL]${NC} ${msg}"
    echo -e "${RED}--------------------------------------------------${NC}"
    echo -e "${RED}【判定】 FAILED... ロジックを見直し、再び挑みたまえ。${NC}"
    exit 1
}

sao_complete() {
    local floor_id="$1"
    echo -e "${GREEN}--------------------------------------------------${NC}"
    echo -e "${GREEN}【判定】 CLEARED! 転移門が開かれた。次層へ進みたまえ！${NC}"
    echo -e "${GREEN}==================================================${NC}"
    if [ "$USE_SOLUTION" -eq 0 ]; then
        local root_dir
        root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ${floor_id} CLEARED" >> "${root_dir}/.sao_progress"
    fi
    exit 0
}
