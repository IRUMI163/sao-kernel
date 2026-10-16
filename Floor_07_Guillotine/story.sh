#!/bin/bash
# ==============================================================================
# SAO: Kernel - Interactive RPG Story Engine (Floor 07)
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
    echo -e "${CYAN}  FLOOR 07 : 記憶の断頭台 (The Guillotine of Memory)${NC}"
    echo -e "${CYAN}==================================================${NC}"
    echo ""
}

# PROLOGUE
clear_screen
show_banner

kayaba_say "「アインクラッド第7層『記憶の断頭台』へようこそ。\n  これまでの戦いで君たちは、関数を抜ければ消滅する『スタック（Stack）の世界』を巡ってきた」"
press_enter

clear_screen
show_banner

kayaba_say "「だがプログラムの実行中に、必要なメモリのサイズが動的に変化する場合はどうする？\n  ここで登場するのが、OSから広大なメモリ空間を借り受ける『ヒープ（Heap）』だ」"
press_enter

clear_screen
show_banner

kayaba_say "「自由なる動的メモリ確保（malloc）には、絶対なる解放（free）の責務が伴う。\n  解放を怠ればメモリリークが、二重解放すれば二重解放エラーの断頭台が首を撥ねるのだ」"
press_enter

# INTERACTIVE Q&A MENU LOOP
while true; do
    clear_screen
    show_banner
    kayaba_say "「何について知りたいのかね？ どの問いにも、この世界の真理をもって答えよう」"

    echo -e "${BOLD}【茅場教官への質問を選択せよ】${NC}"
    echo -e "  ${GREEN}1.${NC} スタックとヒープってメモリの中で何が違うの？"
    echo -e "  ${GREEN}2.${NC} なんで malloc したら絶対に free しなきゃいけないの？"
    echo -e "  ${GREEN}3.${NC} メモリリークや二重解放（Double Free）が起きると何が危険なの？"
    echo -e "  ${GREEN}4.${NC} 【疑問はすべて氷解した】第7層のミッションへ進む"
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
            kayaba_say "「スタックとヒープ。メモリ空間に与えられた性格の異なる2つの領域だな」"
            echo -e "${BOLD}■ 茅場教官の解説：自動管理される『スタック』と、手動管理される広大な『ヒープ』${NC}"
            echo -e "--------------------------------------------------"
            echo -e "・${GREEN}スタック (Stack)${NC} : ローカル変数や関数呼び出しの情報を管理。"
            echo -e "  高速で自動的に確保・解放されるが、サイズが小さく（数MB）、関数を抜けると消滅する。"
            echo -e "・${CYAN}ヒープ (Heap)${NC} : プログラム実行中に malloc で自由なサイズを確保できる広大な領域。"
            echo -e "  関数のスコープを越えて生存できるが、手動で free しない限り永続する。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        2)
            clear_screen
            show_banner
            kayaba_say "「なぜ free が絶対必要なのか。借りたものは返すという自然界の基本原理だ」"
            echo -e "${BOLD}■ 茅場教官の解説：C言語にはガベージコレクション（GC）が存在しない${NC}"
            echo -e "--------------------------------------------------"
            echo -e "Java や Python、Go などの現代言語には、不要になったメモリを自動で回収する"
            echo -e "ガベージコレクタ（GC）が備わっている。"
            echo -e ""
            echo -e "しかし C 言語は、極限のパフォーマンスを引き出すために GC を一切排除している。"
            echo -e "malloc で OS から借り受けたメモリ領域は、君が明示的に free(p) を呼んで返却しない限り"
            echo -e "プロセスが終了するまでメモリ上に不法占有され続けるのだ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        3)
            clear_screen
            show_banner
            kayaba_say "「メモリリークと Double Free。ヒープの支配者を襲う2大崩壊現象だな」"
            echo -e "${BOLD}■ 茅場教官の解説：メモリ枯渇によるサーバーダウンと、管理構造の破壊${NC}"
            echo -e "--------------------------------------------------"
            echo -e "・${RED}メモリリーク (Memory Leak)${NC} : free を忘れ、解放されないメモリが蓄積して最終的に枯渇・クラッシュする。"
            echo -e "・${RED}二重解放 (Double Free)${NC} : すでに free したポインタに対して再度 free(p) を呼び出し、"
            echo -e "  OSのメモリ管理構造（アロケータ）を破壊してセキュリティホールを作る。"
            echo -e ""
            echo -e "free した直後にポインタへ 'p = NULL;' を代入する癖をつけることで、"
            echo -e "Double Free や Use-After-Free の悲劇を防ぐことができるのだ。"
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

kayaba_say "「よし。ヒープと動的メモリ管理の理は理解できたようだな。\n  では、第7層の動的配列・リンクリスト解放ミッションへ進むがいい」"

echo -e "${BOLD}【第7層 ミッション指令書】${NC}"
echo -e "--------------------------------------------------"
echo -e "1. 'MISSION.md' を熟読し、動的メモリ確保とリンクリスト/動的配列の解放仕様を確認せよ。"
echo -e "2. エディタで 'Floor_07_Guillotine/file_list.c' を開き、/* TODO */ を実装せよ。"
echo -e "3. 準備ができたら、自動採点スクリプト './test.sh' を実行してボスを撃破せよ。"
echo -e "--------------------------------------------------"
echo ""

kayaba_say "「君の健闘を祈る。1バイトのリークもなく完全勝利し、緑の『CLEARED!』を刻んでみせたまえ」"

echo -e "${BOLD}次のアクションを選択せよ:${NC}"
echo -e "  ${GREEN}1.${NC} 今すぐボス戦（./test.sh）に挑む"
echo -e "  ${GREEN}2.${NC} 終了してコード編集（file_list.c）を開始する"
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
