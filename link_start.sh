#!/bin/bash
# ==============================================================================
# SAO: Kernel - Master Launcher (LINK START)
# ==============================================================================

CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
MAGENTA='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

clear_screen() {
    clear 2>/dev/null || echo -e "\n--------------------------------------------------"
}

press_enter() {
    echo -e "${YELLOW}[ ⏎ Enterキーを押してメニューに戻る... ]${NC}"
    if [ -t 0 ]; then
        read -r _
    else
        read -r _ 2>/dev/null || true
    fi
}

show_header() {
    echo -e "${CYAN}==================================================${NC}"
    echo -e "${CYAN}  SWORD ART ONLINE : KERNEL - MASTER LAUNCHER${NC}"
    echo -e "${CYAN}  「システムログイン…… リンク・スタート！」${NC}"
    echo -e "${CYAN}==================================================${NC}"
    echo ""
}

show_progress() {
    echo -e "${BOLD}【攻略ステータス】${NC}"
    if [ -f "${SCRIPT_DIR}/.sao_progress" ]; then
        echo -e "${GREEN}"
        cat "${SCRIPT_DIR}/.sao_progress"
        echo -e "${NC}"
    else
        echo -e "  ${YELLOW}まだクリア済みの階層はありません。Floor 01 から挑戦せよ！${NC}\n"
    fi
}

# 各フロアのディレクトリ一覧
FLOORS=(
    "Floor_01_Gate"
    "Floor_02_Labyrinth"
    "Floor_03_SilverPrison"
    "Floor_04_DraftingRoom"
    "Floor_05_Abyss"
    "Floor_06_SoulBlueprint"
    "Floor_07_Guillotine"
    "Floor_08_OuterCorridor"
    "Floor_09_IronWall"
    "Floor_10_RubyPalace"
)

FLOOR_NAMES=(
    "第1層 : 転移門広場 (The Gate of Aincrad)"
    "第2層 : 迷いの森 (The Labyrinth)"
    "第3層 : 白銀の牢獄 (Silver Prison)"
    "第4層 : 迷宮区の製図室 (The Drafting Room)"
    "第5層 : 最深の深淵（中間試験） (The Deepest Abyss)"
    "第6層 : 魂の設計図 (Soul Blueprint)"
    "第7層 : 記憶の断頭台 (The Guillotine of Memory)"
    "第8層 : 外界回廊 (The Outer Corridor)"
    "第9層 : 堅牢なる城壁 (The Iron Wall)"
    "第10層: 紅玉宮 (Ruby Palace - Final Test)"
)

is_cleared() {
    local floor_dir="$1"
    if [ -f "${SCRIPT_DIR}/.sao_progress" ]; then
        grep -q "${floor_dir} CLEARED" "${SCRIPT_DIR}/.sao_progress" 2>/dev/null
        return $?
    fi
    return 1
}

launch_floor_menu() {
    local idx="$1"
    local floor_dir="${FLOORS[$idx]}"
    local floor_title="${FLOOR_NAMES[$idx]}"

    while true; do
        clear_screen
        show_header
        echo -e "${MAGENTA}${BOLD}【選択階層: ${floor_title}】${NC}\n"

        echo -e "${BOLD}実行するアクションを選択せよ:${NC}"
        echo -e "  ${GREEN}1.${NC} ストーリーモードを起動 (${floor_dir}/story.sh)"
        echo -e "  ${GREEN}2.${NC} ボス戦ミッションに挑む (${floor_dir}/test.sh)"
        echo -e "  ${GREEN}3.${NC} メインメニューに戻る"
        echo ""
        echo -n -e "${YELLOW}選択肢 (1-3): ${NC}"

        if [ -t 0 ]; then
            read -r action
        else
            read -r action 2>/dev/null || action="3"
        fi

        case "$action" in
            1)
                clear_screen
                if [ -x "${SCRIPT_DIR}/${floor_dir}/story.sh" ]; then
                    (cd "${SCRIPT_DIR}/${floor_dir}" && ./story.sh)
                else
                    echo -e "${RED}[ERROR] ${floor_dir}/story.sh が見つからないか実行権限がありません。${NC}"
                    press_enter
                fi
                break
                ;;
            2)
                clear_screen
                if [ -x "${SCRIPT_DIR}/${floor_dir}/test.sh" ]; then
                    (cd "${SCRIPT_DIR}/${floor_dir}" && ./test.sh)
                else
                    echo -e "${RED}[ERROR] ${floor_dir}/test.sh が見つからないか実行権限がありません。${NC}"
                fi
                press_enter
                break
                ;;
            3)
                break
                ;;
            *)
                echo -e "${RED}[SYSTEM ERROR] 1から3の番号を入力したまえ。${NC}"
                sleep 1
                ;;
        esac
    done
}

# MAIN LOOP
while true; do
    clear_screen
    show_header
    show_progress

    echo -e "${BOLD}【移動先の階層を選択せよ】${NC}"
    for i in "${!FLOORS[@]}"; do
        num=$((i + 1))
        f_dir="${FLOORS[$i]}"
        f_name="${FLOOR_NAMES[$i]}"
        if is_cleared "$f_dir"; then
            status_tag="${GREEN}[CLEARED]${NC}"
        else
            status_tag="${CYAN}[OPEN]${NC}"
        fi
        echo -e "  ${GREEN}$(printf "%2d" "$num").${NC} ${status_tag} ${f_name}"
    done
    echo -e "  ${GREEN}11.${NC} 全フロアの模範解答一括検証 (make test-solutions)"
    echo -e "  ${GREEN}12.${NC} システムログアウト (Exit)"
    echo ""
    echo -n -e "${YELLOW}選択肢を入力 (1-12): ${NC}"

    if [ -t 0 ]; then
        read -r choice
    else
        read -r choice 2>/dev/null || choice="12"
    fi

    case "$choice" in
        1|2|3|4|5|6|7|8|9|10)
            idx=$((choice - 1))
            launch_floor_menu "$idx"
            ;;
        11)
            clear_screen
            echo -e "${CYAN}[SYSTEM] 全フロアの模範解答 (.solution) を検証中...${NC}\n"
            make -C "${SCRIPT_DIR}" test-solutions
            press_enter
            ;;
        12)
            echo ""
            echo -e "${CYAN}[SYSTEM] ログアウトしました。Good luck, Player!${NC}"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}[SYSTEM ERROR] 1から12の番号を入力したまえ。${NC}"
            sleep 1
            ;;
    esac
done
