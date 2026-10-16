#!/bin/bash
# ==============================================================================
# SAO: Kernel - Interactive RPG Story Engine (Floor 04)
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
    echo -e "${CYAN}  FLOOR 04 : 迷宮区の製図室 (The Drafting Room)${NC}"
    echo -e "${CYAN}==================================================${NC}"
    echo ""
}

# PROLOGUE
clear_screen
show_banner

kayaba_say "「巨大な城郭アインクラッドを単一の設計図で記述することは不可能だ。\n  優れた職人は、城壁、部屋、仕掛けの設計図をそれぞれ独立した羊皮紙に分割し、組み上げる」"
press_enter

clear_screen
show_banner

kayaba_say "「ようこそ第4層『迷宮区の製図室』へ。\n  ここではソースコードを機能ごとに分割し、再利用可能なモジュールを作る手法を学ぶ」"
press_enter

clear_screen
show_banner

kayaba_say "「プログラミングの本質は複雑さとの戦いだ。\n  設計図（.h）と実装（.c）を美しく分離し、分割コンパイルの技法を身につけたまえ」"
press_enter

# INTERACTIVE Q&A MENU LOOP
while true; do
    clear_screen
    show_banner
    kayaba_say "「何について知りたいのかね？ どの問いにも、この世界の真理をもって答えよう」"

    echo -e "${BOLD}【茅場教官への質問を選択せよ】${NC}"
    echo -e "  ${GREEN}1.${NC} なんでわざわざ '.c' と '.h' にファイルを分けるの？"
    echo -e "  ${GREEN}2.${NC} インクルードガード（#ifndef）って何から身を守ってるの？"
    echo -e "  ${GREEN}3.${NC} 分割コンパイルや Makefile ってどんな役割を持つの？"
    echo -e "  ${GREEN}4.${NC} 【疑問はすべて氷解した】第4層のミッションへ進む"
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
            kayaba_say "「.c と .h の分離。まさに大規模ソフトウェアのモジュール化の原点だな」"
            echo -e "${BOLD}■ 茅場教官の解説：『公開仕様（インターフェース）』と『内部実装』の分離${NC}"
            echo -e "--------------------------------------------------"
            echo -e "・${GREEN}ヘッダファイル (.h)${NC} : 関数のプロトタイプ宣言や型定義を記述する『取扱説明書』。"
            echo -e "  他モジュールから呼び出せる機能の仕様のみを公開する。"
            echo -e "・${CYAN}ソースファイル (.c)${NC} : 実際のアルゴリズムや処理ロジックを記述する『内部実装』。"
            echo -e ""
            echo -e "このように分離することで、呼び出し側は内部の複雑な実装を知る必要がなくなり、"
            echo -e "実装を変更しても .h のインターフェースが変わらなければ"
            echo -e "他のプログラムへ影響を及ぼさずに済むのだ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        2)
            clear_screen
            show_banner
            kayaba_say "「インクルードガード（#ifndef / #define / #endif）。二重定義の混乱を防ぐ盾だ」"
            echo -e "${BOLD}■ 茅場教官の解説：ヘッダファイルの重複読み込みによるコンパイルエラーを防ぐメカニズム${NC}"
            echo -e "--------------------------------------------------"
            echo -e "複数の .c や .h から同じヘッダファイルが #include されると、"
            echo -e "プリプロセッサによって同じ構造体や関数宣言が何重にも展開され、"
            echo -e "'redefinition of ...' （二重定義エラー）でコンパイルが停止する。"
            echo -e ""
            echo -e "これを防ぐため、ヘッダの先頭と末尾に次のおまじない（インクルードガード）を記述する。"
            echo -e "  #ifndef CALC_H"
            echo -e "  #define CALC_H"
            echo -e "  /* 宣言群 */"
            echo -e "  #endif"
            echo -e "一度読み込まれたシンボルを記憶し、2回目以降の展開をスキップさせる自己防衛機構なのだ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        3)
            clear_screen
            show_banner
            kayaba_say "「分割コンパイルと Makefile。ビルド時間を最小化する賢者の自動化ツールだな」"
            echo -e "${BOLD}■ 茅場教官の解説：変更されたファイルだけを再コンパイルし、リンカで1つに繋ぐ${NC}"
            echo -e "--------------------------------------------------"
            echo -e "100 万行のソースコードがある巨大プロジェクトで、1 行直すたびに"
            echo -e "全ファイルを再コンパイルしていたら日が暮れてしまう。"
            echo -e ""
            echo -e "分割コンパイルでは、各 .c を独立してオブジェクトファイル (.o) に変換し、"
            echo -e "最後にリンカ（linker）がそれらを結合して executable バイナリを生成する。"
            echo -e "Makefile はファイルのタイムスタンプを自動比較し、"
            echo -e "『変更があったファイルとその依存関係だけ』を最小限に再ビルドしてくれるのだ。"
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

kayaba_say "「よし。ファイル分離とモジュール化の構造は理解できたようだな。\n  では、製図室の分割ビルドミッションに挑戦したまえ」"

echo -e "${BOLD}【第4層 ミッション指令書】${NC}"
echo -e "--------------------------------------------------"
echo -e "1. 'MISSION.md' を熟読し、ヘッダファイル calc.h と calc.c の分割構造を確認せよ。"
echo -e "2. エディタで 'Floor_04_DraftingRoom/calc.c' や 'calc.h' を開き、/* TODO */ を実装せよ。"
echo -e "3. 準備ができたら、自動採点スクリプト './test.sh' を実行してボスを撃破せよ。"
echo -e "--------------------------------------------------"
echo ""

kayaba_say "「君の健闘を祈る。分割コンパイルを成功させ、緑の『CLEARED!』を刻んでみせたまえ」"

echo -e "${BOLD}次のアクションを選択せよ:${NC}"
echo -e "  ${GREEN}1.${NC} 今すぐボス戦（./test.sh）に挑む"
echo -e "  ${GREEN}2.${NC} 終了してコード編集（calc.c）を開始する"
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
