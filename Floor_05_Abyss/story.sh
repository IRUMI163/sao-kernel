#!/bin/bash
# ==============================================================================
# SAO: Kernel - Interactive RPG Story Engine (Floor 05)
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
    echo -e "${CYAN}  FLOOR 05 : 最深の深淵（中間試験） (The Deepest Abyss)${NC}"
    echo -e "${CYAN}==================================================${NC}"
    echo ""
}

# PROLOGUE
clear_screen
show_banner

kayaba_say "「プレイヤー諸君、ようこそ第5層『最深の深淵』へ。\n  ここは諸君にとって最初の大いなる壁、すなわち『中間試験』の舞台だ」"
press_enter

clear_screen
show_banner

kayaba_say "「これまで扱ってきた変数は、値そのものを直接操作するものだった。\n  だがC言語の真の力と恐怖は、値ではなく『メモリのアドレス（番地）』を直接操作する領域……\n  禁断の『ポインタ』にある」"
press_enter

clear_screen
show_banner

kayaba_say "「ポインタを克服せぬ者に、これより先の階層へ進む資格はない。\n  深淵の底に呑み込まれる前に、ポインタの真理を掴み取るのだ」"
press_enter

# INTERACTIVE Q&A MENU LOOP
while true; do
    clear_screen
    show_banner
    kayaba_say "「何について知りたいのかね？ どの問いにも、この世界の真理をもって答えよう」"

    echo -e "${BOLD}【茅場教官への質問を選択せよ】${NC}"
    echo -e "  ${GREEN}1.${NC} ポインタって結局メモリの何を指してるの？（住所と部屋番号）"
    echo -e "  ${GREEN}2.${NC} アドレス '&' と間接参照 '*' の違いが分からない！"
    echo -e "  ${GREEN}3.${NC} セグフォ（Segmentation Fault）ってなんで起きるの？"
    echo -e "  ${GREEN}4.${NC} 【疑問はすべて氷解した】第5層の中間試験へ進む"
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
            kayaba_say "「ポインタの本質か。現実世界の『住所（メモリアドレス）』で考えれば何も難しくない」"
            echo -e "${BOLD}■ 茅場教官の解説：ポインタ変数は『データが置かれているメモリの住所』を保持する変数${NC}"
            echo -e "--------------------------------------------------"
            echo -e "通常の変数 int hp = 100; は、メモリという巨大ホテルの『ある部屋』に"
            echo -e "数値 100 という荷物を置いている状態だ。"
            echo -e ""
            echo -e "一方、ポインタ変数 int *p = &hp; は、荷物そのものではなく"
            echo -e "『hp ちゃんが泊まっている部屋番号（0x7ffee4b2）』を紙にメモした変数なのだ。"
            echo -e ""
            echo -e "ポインタ自体もただの変数であり、64bit CPU であれば 8 バイトのサイズで"
            echo -e "『メモリの住所』を記憶しているに過ぎん。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        2)
            clear_screen
            show_banner
            kayaba_say "「'&'（アドレス参照）と '*'（間接参照・デリファレンス）か。表裏一体の演算子だな」"
            echo -e "${BOLD}■ 茅場教官の解説：'&' は住所を調べる、'*' は住所を訪ねて中身を取り出す/書き換える${NC}"
            echo -e "--------------------------------------------------"
            echo -e "・${GREEN}&x (アドレス参照演算子)${NC} : 変数 x が置かれているメモリの『住所』を取り出す。"
            echo -e "・${CYAN}*p (間接参照演算子)${NC} : ポインタ p に書かれた住所を実際に訪問し、"
            echo -e "  その部屋にある『値』を読み書きする。"
            echo -e ""
            echo -e "関数に引数を渡す際、値のコピーではなく '&x' で住所を渡す（参照渡し）ことで、"
            echo -e "呼び出し先の関数内から呼び出し元の変数を直接書き換えることが可能になる。"
            echo -e "これが C 言語におけるポインタ渡しの核心だ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        3)
            clear_screen
            show_banner
            kayaba_say "「セグフォ（Segmentation Fault）。OSが下す最も非情な死刑判決だな」"
            echo -e "${BOLD}■ 茅場教官の解説：許可されていないメモリ領域への違法アクセス検知${NC}"
            echo -e "--------------------------------------------------"
            echo -e "ポインタが NULL（0x0）を指しているのに '*p' でアクセスしようとしたり（ヌルポインタアクセス）、"
            echo -e "すでに解放された領域や、OSが保護している未割り当てのメモリアドレスへ侵入した瞬間、"
            echo -e "CPU と OS のメモリ管理機構（MMU）が違反を検知し、即座にプロセスを強制終了する。"
            echo -e ""
            echo -e "これが Segmentation Fault だ。"
            echo -e "ポインタを扱う時は、アクセス前に必ず 'if (p != NULL)' のチェックを行うのだ。"
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

kayaba_say "「よし。ポインタとメモリ番地の理は頭に入ったようだな。\n  では、中間試験に挑むがいい」"

echo -e "${BOLD}【第5層 ミッション指令書（中間試験）】${NC}"
echo -e "--------------------------------------------------"
echo -e "1. 'MISSION.md' を熟読し、ポインタ直接操作によるメモリ書き換え仕様を確認せよ。"
echo -e "2. エディタで 'Floor_05_Abyss/main.c' を開き、/* TODO */ を実装せよ。"
echo -e "3. 準備ができたら、自動採点スクリプト './test.sh' を実行して中間試験を突破せよ。"
echo -e "--------------------------------------------------"
echo ""

kayaba_say "「君の健闘を祈る。深淵を乗り越え、緑の『CLEARED!』を刻んでみせたまえ」"

echo -e "${BOLD}次のアクションを選択せよ:${NC}"
echo -e "  ${GREEN}1.${NC} 今すぐボス戦（./test.sh）に挑む"
echo -e "  ${GREEN}2.${NC} 終了してコード編集（main.c）を開始する"
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
