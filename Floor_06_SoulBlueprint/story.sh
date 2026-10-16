#!/bin/bash
# ==============================================================================
# SAO: Kernel - Interactive RPG Story Engine (Floor 06)
# Character: Akihiko Kayaba (Heathcliff)
# ==============================================================================

CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
MAGENTA='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

clear_screen() {
    clear 2>/dev/null || echo -e "\n--------------------------------------------------"
}

press_enter() {
    echo -e "${YELLOW}[ ⏎ Enterキーを押して次へ進む... ]${NC}"
    if [ -t 0 ]; then
        read -r _
    else
        read -r _ 2>/dev/null || true
    fi
}

kayaba_say() {
    echo -e "${CYAN}${BOLD}【茅場晶彦】${NC}"
    echo -e "$1"
    echo ""
}

show_banner() {
    echo -e "${CYAN}==================================================${NC}"
    echo -e "${CYAN}  SWORD ART ONLINE : KERNEL - STORY MODE${NC}"
    echo -e "${CYAN}  FLOOR 06 : 魂の設計図 (Soul Blueprint)${NC}"
    echo -e "${CYAN}==================================================${NC}"
    echo ""
}

# PROLOGUE
clear_screen
show_banner

kayaba_say "「アインクラッド第6層へようこそ。\n  これまで君たちは、単一の数値や文字列といったバラバラのデータを扱ってきた」"
press_enter

clear_screen
show_banner

kayaba_say "「だが現実のデータ構造——例えばプレイヤーのステータス（名前、HP、Level、装備）は、\n  バラバラの変数ではなく、ひとつの意味ある単位として束ねられるべきだ。\n  それこそが『構造体（struct）』——データモデリングの真髄である」"
press_enter

clear_screen
show_banner

kayaba_say "「複雑なデータを設計・制御する魂の設計図を手にし、第6層を攻略してみせたまえ」"
press_enter

# INTERACTIVE Q&A MENU LOOP
while true; do
    clear_screen
    show_banner
    kayaba_say "「何について知りたいのかね？ どの問いにも、この世界の真理をもって答えよう」"

    echo -e "${BOLD}【茅場教官への質問を選択せよ】${NC}"
    echo -e "  ${GREEN}1.${NC} 構造体（struct）って普通の変数と何が違うの？"
    echo -e "  ${GREEN}2.${NC} ドット '.' とアロー '->' はどう使い分けるの？"
    echo -e "  ${GREEN}3.${NC} 構造体のサイズが単純な合計値にならない（パディング）のはなぜ？"
    echo -e "  ${GREEN}4.${NC} 【疑問はすべて氷解した】第6層のミッションへ進む"
    echo ""
    echo -n -e "${YELLOW}選択肢を入力 (1-4): ${NC}"

    if [ -t 0 ]; then
        read -r choice
    else
        read -r choice 2>/dev/null || choice="4"
    fi

    case "$choice" in
        1)
            clear_screen
            show_banner
            kayaba_say "「構造体（struct）か。複数の変数を『1つのカスタム型』としてパッケージ化する道具だな」"
            echo -e "${BOLD}■ 茅場教官の解説：異なる型（int, char, double...）をメモリ上で1つに束ねる複合型${NC}"
            echo -e "--------------------------------------------------"
            echo -e "配列は『同じ型のデータの集まり』だが、"
            echo -e "構造体は『異なる型のデータを自由な組み合わせで1つの塊にしたもの』だ。"
            echo -e ""
            echo -e "  struct Player {"
            echo -e "      char name[32];"
            echo -e "      int hp;"
            echo -e "      int level;"
            echo -e "  };"
            echo -e ""
            echo -e "こう定義することで 'struct Player p1;' という変数を作るだけで、"
            echo -e "名前・HP・レベルをひとまとめにして関数の引数に渡したり受け取ったりできるのだ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        2)
            clear_screen
            show_banner
            kayaba_say "「ドット '.' とアロー '->' の使い分け。構造体の『実体』か『ポインタ』かの違いだ」"
            echo -e "${BOLD}■ 茅場教官の解説：実体アクセスは '.'、ポインタ経由アクセスは '->'${NC}"
            echo -e "--------------------------------------------------"
            echo -e "・${GREEN}構造体の実体変数 (Player p1)${NC} : メンバへ直接アクセスする場合はドット演算子を使う。"
            echo -e "  例: p1.hp = 100;"
            echo -e ""
            echo -e "・${CYAN}構造体へのポインタ (Player *p)${NC} : ポインタ経由でアクセスする場合はアロー演算子を使う。"
            echo -e "  例: p->hp = 100;  （これは (*p).hp = 100; の糖衣構文＝ショートカットだ）"
            echo -e ""
            echo -e "構造体はサイズが大きいため、関数へ渡す時はコピーの無駄を避けて"
            echo -e "ポインタ渡しを行うのが常套手段だ。よってアロー演算子 '->' が多用される。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        3)
            clear_screen
            show_banner
            kayaba_say "「構造体のパディング（メモリ・アライメント）。CPUの効率追求が生む隙間だな」"
            echo -e "${BOLD}■ 茅場教官の解説：CPUが最速でメモリを読み込めるようバイト境界に配置を揃える${NC}"
            echo -e "--------------------------------------------------"
            echo -e "char (1バイト) と int (4バイト) を持つ構造体があるとする。"
            echo -e "合計は 5 バイトに見えるが、sizeof() で測ると 8 バイトになる。"
            echo -e ""
            echo -e "なぜか？ 64bit CPU は 4バイトや 8バイト単位でメモリにアクセスする方が高速なため、"
            echo -e "コンパイラが自動的に 3 バイトのパディング（隙間・詰め物）を挿入するからだ。"
            echo -e "メモリ配置の物理的な美しさとパフォーマンスの理がここにある。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        4)
            break
            ;;
        *)
            echo -e "${RED}[SYSTEM ERROR] 1から4の番号を入力したまえ。${NC}"
            sleep 1
            ;;
    esac
done

# EPILOGUE & MISSION BRIEFING
clear_screen
show_banner

kayaba_say "「よし。構造体とデータモデリングの理は理解できたようだな。\n  では、第6層のオプション解析ライブラリミッションに挑むがいい」"

echo -e "${BOLD}【第6層 ミッション指令書】${NC}"
echo -e "--------------------------------------------------"
echo -e "1. 'MISSION.md' を熟読し、構造体を用いたオプション引数パース構造を確認せよ。"
echo -e "2. エディタで 'Floor_06_SoulBlueprint/arg_parser.c' を開き、/* TODO */ を実装せよ。"
echo -e "3. 準備ができたら、自動採点スクリプト './test.sh' を実行してボスを撃破せよ。"
echo -e "--------------------------------------------------"
echo ""

kayaba_say "「君の健闘を祈る。データ構造を使いこなし、緑の『CLEARED!』を刻んでみせたまえ」"

echo -e "${BOLD}次のアクションを選択せよ:${NC}"
echo -e "  ${GREEN}1.${NC} 今すぐボス戦（./test.sh）に挑む"
echo -e "  ${GREEN}2.${NC} 終了してコード編集（arg_parser.c）を開始する"
echo ""
echo -n -e "${YELLOW}選択肢 (1-2): ${NC}"

if [ -t 0 ]; then
    read -r next_action
else
    read -r next_action 2>/dev/null || next_action="2"
fi

if [ "$next_action" = "1" ]; then
    echo ""
    echo -e "${CYAN}[SYSTEM] ボス戦（./test.sh）を開始します...${NC}"
    echo ""
    ./test.sh
else
    echo ""
    echo -e "${GREEN}[SYSTEM] ストーリーモードを終了しました。${NC}"
    echo -e "コードを編集後、いつでも ${CYAN}./test.sh${NC} または ${CYAN}./story.sh${NC} を実行してください。"
    echo ""
fi

exit 0
