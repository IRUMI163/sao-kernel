#!/bin/bash
# ==============================================================================
# SAO: Kernel - Interactive RPG Story Engine (Floor 10)
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
    echo -e "${CYAN}  FLOOR 10 : 紅玉宮 (Ruby Palace - Final Test)${NC}"
    echo -e "${CYAN}==================================================${NC}"
    echo ""
}

# PROLOGUE
clear_screen
show_banner

kayaba_say "「よくぞここまで辿り着いた、勇敢なるプログラマたちよ。\n  ここは浮遊城アインクラッド最上層——紅玉宮」"
press_enter

clear_screen
show_banner

kayaba_say "「1層での変数・出力から始まり、ポインタ、構造体、動的メモリ、ファイル操作、エラー処理……\n  君たちは低レイヤにおけるすべての試練を乗り越えてきた」"
press_enter

clear_screen
show_banner

kayaba_say "「最後の試練は、これまでの学びをひとつに統合し、\n  実用的かつ完全なる CLI ツール『gear』をビルド・デプロイすることだ。\n  さあ、私を超えてみせたまえ！」"
press_enter

# INTERACTIVE Q&A MENU LOOP
while true; do
    clear_screen
    show_banner
    kayaba_say "「何について知りたいのかね？ 最後の問いにも、この世界の真理をもって答えよう」"

    echo -e "${BOLD}【茅場教官への質問を選択せよ】${NC}"
    echo -e "  ${GREEN}1.${NC} システムコールって普通のC言語の関数と何が違うの？"
    echo -e "  ${GREEN}2.${NC} 自分で作ったコマンドを『PATH』に通すってどういうこと？"
    echo -e "  ${GREEN}3.${NC} 完全なバイナリとしてビルド・デプロイするために必要なこととは？"
    echo -e "  ${GREEN}4.${NC} 【疑問はすべて氷解した】第10層の最終試験へ進む"
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
            kayaba_say "「システムコール（System Call）。ユーザー空間とカーネル空間を隔てる特権の壁だな」"
            echo -e "${BOLD}■ 茅場教官の解説：ハードウェアやOSのリソースを直接操作する唯一の扉${NC}"
            echo -e "--------------------------------------------------"
            echo -e "普通の C 言語関数（strlen や abs）は、ユーザー空間内で閉じている。"
            echo -e "対して read, write, open, fork 等のシステムコールは、"
            echo -e "CPU の特権モード（カーネルモード）へと割り込み（syscall / int 0x80）を発生させ、"
            echo -e "OS カーネルにしか許されない処理を実行させる。"
            echo -e ""
            echo -e "C標準ライブラリ（printf や fopen）も、内部ではシステムコール（write や open）を"
            echo -e "呼び出しているに過ぎない。君たちはカーネルの力を操っているのだ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        2)
            clear_screen
            show_banner
            kayaba_say "「PATH 環境変数。自作ツールをシステムの一部へと統合する儀式だな」"
            echo -e "${BOLD}■ 茅場教官の解説：シェルが実行ファイルを検索するディレクトリの優先リスト${NC}"
            echo -e "--------------------------------------------------"
            echo -e "ターミナルで 'ls' や 'gcc' と入力した時、"
            echo -e "シェルは PATH 環境変数に登録されたディレクトリ（/usr/bin, /usr/local/bin 等）から"
            echo -e "一致する実行可能ファイルを探し出して起動している。"
            echo -e ""
            echo -e "完成したバイナリ 'gear' を ~/.local/bin や /usr/local/bin に配置し、"
            echo -e "PATH を通すことで、パス指定なしで全システムから『gear』コマンドとして"
            echo -e "一発起動できるようになる。真のソフトウェアデプロイの到達点だ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        3)
            clear_screen
            show_banner
            kayaba_say "「完全なるビルドとデプロイ。プロダクションクオリティへ達するための誓約だ」"
            echo -e "${BOLD}■ 茅場教官の解説：厳格コンパイル、ASan検証、エラーハンドリング、そして美意識${NC}"
            echo -e "--------------------------------------------------"
            echo -e "ただ動くだけのコードは誰にでも書ける。"
            echo -e "・1つの警告（-Wall -Wextra -Werror）も許さぬこと"
            echo -e "・1バイトのメモリリーク（ASan）も残さぬこと"
            echo -e "・不適切な入力に屈せず、適切な stderr と exit status を返すこと"
            echo -e "・可読性とモジュール性を追求した美しきコードであること"
            echo -e ""
            echo -e "これらをすべて満たした時、君のコードはアインクラッドを完全攻略し、"
            echo -e "世界を変える本物のソフトウェアとなるのだ。"
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

kayaba_say "「すべての理は伝授した。\n  さあ、浮遊城アインクラッド最上層、最終テストに挑みたまえ！」"

echo -e "${BOLD}【第10層 最終ミッション指令書】${NC}"
echo -e "--------------------------------------------------"
echo -e "1. 'MISSION.md' を熟読し、CLIツール 'gear' の最終統合ビルド仕様を確認せよ。"
echo -e "2. エディタで 'Floor_10_RubyPalace/main.c' を開き、/* TODO */ を実装せよ。"
echo -e "3. 準備ができたら、自動採点スクリプト './test.sh' を実行してアインクラッドを完全クリアせよ！"
echo -e "--------------------------------------------------"
echo ""

kayaba_say "「君の健闘を祈る。伝説を創り出し、緑の『CLEARED!』を刻んでみせたまえ」"

echo -e "${BOLD}次のアクションを選択せよ:${NC}"
echo -e "  ${GREEN}1.${NC} 今すぐ最終ボス戦（./test.sh）に挑む"
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
    echo -e "${CYAN}[SYSTEM] 最終ボス戦（./test.sh）を開始します...${NC}"
    echo ""
    ./test.sh
else
    echo ""
    echo -e "${GREEN}[SYSTEM] ストーリーモードを終了しました。${NC}"
    echo -e "コードを編集後、いつでも ${CYAN}./test.sh${NC} または ${CYAN}./story.sh${NC} を実行してください。"
    echo ""
fi

exit 0
