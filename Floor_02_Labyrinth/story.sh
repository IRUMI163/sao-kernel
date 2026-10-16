#!/bin/bash
# ==============================================================================
# SAO: Kernel - Interactive RPG Story Engine (Floor 02)
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
    echo -e "${CYAN}  FLOOR 02 : 迷いの森 (The Labyrinth)${NC}"
    echo -e "${CYAN}==================================================${NC}"
    echo ""
}

# PROLOGUE
clear_screen
show_banner

kayaba_say "「第1層の単純な一本道を破り、ようこそ第2層『迷いの森』へ。\n  ここからの世界は、二度と同じ表情を見せない」"
press_enter

clear_screen
show_banner

kayaba_say "「外部からの入力（コマンドライン引数）に応じ、\n  プログラムは自ら道を判断し、条件に応じて幾重にも分岐せねばならん。\n  静的な出力を繰り返すだけのコードは、ここでは一歩も前進できず消滅するのだ」"
press_enter

clear_screen
show_banner

kayaba_say "「条件分岐 'if-else' と反復 'for' を手に入れ、プログラムに『思考する意志』を吹き込むのだ。\n  まずは、この階層で君の行く手を阻む疑問を私にぶつけてみたまえ」"
press_enter

# INTERACTIVE Q&A MENU LOOP
while true; do
    clear_screen
    show_banner
    kayaba_say "「何について知りたいのかね？ どの問いにも、この世界の真理をもって答えよう」"

    echo -e "${BOLD}【茅場教官への質問を選択せよ】${NC}"
    echo -e "  ${GREEN}1.${NC} 『argc』と『argv』って何ですか？"
    echo -e "  ${GREEN}2.${NC} なんで文字列比較に '==' が使えないの？（strcmpの理由）"
    echo -e "  ${GREEN}3.${NC} 『早期リターン』って何がすごいの？"
    echo -e "  ${GREEN}4.${NC} 【疑問はすべて氷解した】第2層のミッションへ進む"
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
            kayaba_say "「『argc』と『argv』か。プログラムが外部世界と対話するための『言葉の窓口』だな」"
            echo -e "${BOLD}■ 茅場教官の解説：コマンドラインから渡される引数の『数』と『配列』${NC}"
            echo -e "--------------------------------------------------"
            echo -e "C言語の main 関数は、起動時に OS からパラメータを受け取ることができる。"
            echo -e "・${GREEN}argc (Argument Count)${NC} : 渡された引数の『個数』を表す整数。"
            echo -e "  注意すべきは、プログラム名自体（./floor_runner 等）も 1 つ目として数えられる点だ。"
            echo -e "・${GREEN}argv (Argument Vector)${NC} : 各引数文字列へのポインタ配列。"
            echo -e "  argv[0] には実行ファイル名、argv[1] には第1オプションが入る。"
            echo -e ""
            echo -e "もし argc のチェックを怠り、存在しない argv[1] にアクセスすれば、"
            echo -e "プログラムは即座にセグメンテーション違反で暴走・クラッシュする。"
            echo -e "境界線を守る者だけが、迷いの森を脱出できるのだ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        2)
            clear_screen
            show_banner
            kayaba_say "「なぜ文字列同士を '==' で比較してはならんのか……初心者が必ず陥る罠だな」"
            echo -e "${BOLD}■ 茅場教官の解説：C言語の '==' は文字列の中身ではなく『メモリ番地』を比較する${NC}"
            echo -e "--------------------------------------------------"
            echo -e "C言語には『文字列型』という単一の基本型が存在しない。"
            echo -e "文字列とは、メモリ上に並んだ char 配列の先頭アドレスに過ぎんのだ。"
            echo -e ""
            echo -e "したがって 'argv[1] == \"-h\"' と書くと、文字の中身ではなく"
            echo -e "『argv[1] が指すメモリ番地』と『\"-h\" が置かれたメモリ番地』が等しいかを判定してしまう。"
            echo -e "中身が全く同じ \"-h\" であっても、番地が異なれば偽（False）となるのだ。"
            echo -e ""
            echo -e "文字列の『中身』を1文字ずつ等しいか調べるには、"
            echo -e "<string.h> の ${CYAN}strcmp(s1, s2)${NC} を使わねばならん。"
            echo -e "一致したときに ${GREEN}0${NC} を返す点も忘れるなよ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        3)
            clear_screen
            show_banner
            kayaba_say "「早期リターン（Early Return）。美しく堅牢なコードを書くための必修思想だ」"
            echo -e "${BOLD}■ 茅場教官の解説：異常系を冒頭で弾き、ネストの深み（迷宮）を防ぐ${NC}"
            echo -e "--------------------------------------------------"
            echo -e "初心者はしばしば、条件分岐を deep にネストさせ、if の中に if を重ねてコードを複雑にする。"
            echo -e "『引数が足りない』『オプションが無効』といった不正条件は、"
            echo -e "関数の冒頭で即座に検知し、エラー出力とともに return して抜け出すのだ。"
            echo -e ""
            echo -e "ガード節（Guard Clause）によって不正なアクセスを門前払いすることで、"
            echo -e "正常系の処理はネストのないクリアな一本道として記述できる。"
            echo -e "迷いの森で道に迷わないための、最良のコンパスと言えよう。"
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

kayaba_say "「よし。分岐と反復の理は理解できたようだな。\n  では、第2層の試練へと進むがいい」"

echo -e "${BOLD}【第2層 ミッション指令書】${NC}"
echo -e "--------------------------------------------------"
echo -e "1. 'MISSION.md' を熟読し、要求されるコマンドライン解析仕様（-h, -v, memo, エラー処理等）を確認せよ。"
echo -e "2. エディタで 'Floor_02_Labyrinth/main.c' を開き、/* TODO */ を実装せよ。"
echo -e "3. 準備ができたら、自動採点スクリプト './test.sh' を実行してボスを撃破せよ。"
echo -e "--------------------------------------------------"
echo ""

kayaba_say "「君の健闘を祈る。迷いの森を突破し、緑の『CLEARED!』を刻んでみせたまえ」"

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
