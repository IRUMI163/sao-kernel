#!/bin/bash
# ==============================================================================
# SAO: Kernel - Interactive RPG Story Engine (Floor 03)
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
    echo -e "${CYAN}  FLOOR 03 : 白銀の牢獄 (Silver Prison)${NC}"
    echo -e "${CYAN}==================================================${NC}"
    echo ""
}

# PROLOGUE
clear_screen
show_banner

kayaba_say "「ようこそ、第3層『白銀の牢獄』へ。\n  これまでの単一の変数は、メモリ空間に浮かぶ点に過ぎなかった」"
press_enter

clear_screen
show_banner

kayaba_say "「ここ第3層で君たちが向き合うのは、連続したメモリ領域——『配列』と『文字列』だ。\n  だがC言語において、独立した文字列型など存在しない。\n  それは単なる char の配列であり、終端を示すのは唯一無二の存在、終端文字 '\\0' のみだ」"
press_enter

clear_screen
show_banner

kayaba_say "「この一文字を見失えば、プログラムは境界を突き破り、バッファオーバーフローを引き起こす。\n  白銀の牢獄で囚われの身とならぬよう、まずは疑問を解消したまえ」"
press_enter

# INTERACTIVE Q&A MENU LOOP
while true; do
    clear_screen
    show_banner
    kayaba_say "「何について知りたいのかね？ どの問いにも、この世界の真理をもって答えよう」"

    echo -e "${BOLD}【茅場教官への質問を選択せよ】${NC}"
    echo -e "  ${GREEN}1.${NC} 終端文字 '\\0' ってなんでそんなに絶対必要なの？"
    echo -e "  ${GREEN}2.${NC} バッファオーバーフローってメモリのどこが壊れるの？"
    echo -e "  ${GREEN}3.${NC} オフバイワンエラー（Off-by-One Error）ってなに？"
    echo -e "  ${GREEN}4.${NC} 【疑問はすべて氷解した】第3層のミッションへ進む"
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
            kayaba_say "「終端文字 '\\0' (ヌル文字)。C言語の文字列における『生命線』だな」"
            echo -e "${BOLD}■ 茅場教官の解説：メモリ上に長さの情報を持たないC言語文字列の『目印』${NC}"
            echo -e "--------------------------------------------------"
            echo -e "C言語の char 配列は、単なるバイトの連続に過ぎない。"
            echo -e "printf 等の関数は、メモリを先頭から1バイトずつ読み進め、"
            echo -e "値が 0（'\\0'）になった瞬間に『ここで文字列が終わりだ』と判断する。"
            echo -e ""
            echo -e "もし '\\0' を書き忘れた場合、関数は配列の境界を越えて"
            echo -e "隣接する無関係なメモリ領域まで読み続け、ゴミデータを出力したり"
            echo -e "セグメンテーション違反を引き起こす。"
            echo -e "文字列サイズ N に対して有効文字は最大 N-1 文字。1バイトの '\\0' 枠を絶対に残さねばならん。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        2)
            clear_screen
            show_banner
            kayaba_say "「バッファオーバーフロー（BOF）。かつて数多のシステムを滅ぼした伝説の脆弱性だ」"
            echo -e "${BOLD}■ 茅場教官の解説：確保した領域を溢れ出たデータが、隣接領域やスタックを破壊する${NC}"
            echo -e "--------------------------------------------------"
            echo -e "例えば 10 バイト確保した配列に 20 バイトのデータを書き込むと、"
            echo -e "溢れた 10 バイトは隣の変数や関数の戻り先アドレス（リターンアドレス）を上書きする。"
            echo -e ""
            echo -e "安全性のない strcpy や strcat を無防備に使うのは、"
            echo -e "防具なしでボスモンスターに突撃するようなものだ。"
            echo -e "常にバッファの最大サイズ（dest_size）を意識し、溢れを事前に切り詰める"
            echo -e "防御的プログラミング（Defensive Programming）を徹底せよ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        3)
            clear_screen
            show_banner
            kayaba_say "「オフバイワンエラー（Off-by-One Error）。プログラマの油断につけ込む『1』の魔物だ」"
            echo -e "${BOLD}■ 茅場教官の解説：インデックスの 0 始まりと '<=' の勘違いから生じる境界ミス${NC}"
            echo -e "--------------------------------------------------"
            echo -e "サイズ 10 の配列 buf[10] の有効インデックスは 0 から 9 までだ。"
            echo -e "しかし 'for (int i = 0; i <= 10; i++)' のように '<=' と書いてしまうと、"
            echo -e "i=10 のとき（11回目のアクセス）に領域外を侵してしまう。"
            echo -e ""
            echo -e "また、終端文字 '\\0' の 1 バイトを確保し忘れて 'dest_size' 文字コピーするのも"
            echo -e "典型的なオフバイワンエラーだ。"
            echo -e "たった '1' のズレが、白銀の牢獄の扉を永久に閉ざすことになるのだよ。"
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

kayaba_say "「良し。境界と終端文字の理は理解できたようだな。\n  では、第3層の安全文字列ライブラリ作成ミッションへ挑むがいい」"

echo -e "${BOLD}【第3層 ミッション指令書】${NC}"
echo -e "--------------------------------------------------"
echo -e "1. 'MISSION.md' を熟読し、要求される safe_str_copy および safe_path_join の仕様を確認せよ。"
echo -e "2. エディタで 'Floor_03_SilverPrison/safe_str.c' を開き、/* TODO */ を実装せよ。"
echo -e "3. 準備ができたら、自動採点スクリプト './test.sh' を実行してボスを撃破せよ。"
echo -e "--------------------------------------------------"
echo ""

kayaba_say "「君の健闘を祈る。ASanの検証を破り、緑の『CLEARED!』を刻んでみせたまえ」"

echo -e "${BOLD}次のアクションを選択せよ:${NC}"
echo -e "  ${GREEN}1.${NC} 今すぐボス戦（./test.sh）に挑む"
echo -e "  ${GREEN}2.${NC} 終了してコード編集（safe_str.c）を開始する"
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
