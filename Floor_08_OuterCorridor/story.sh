#!/bin/bash
# ==============================================================================
# SAO: Kernel - Interactive RPG Story Engine (Floor 08)
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
    echo -e "${CYAN}  FLOOR 08 : 外界回廊 (The Outer Corridor)${NC}"
    echo -e "${CYAN}==================================================${NC}"
    echo ""
}

# PROLOGUE
clear_screen
show_banner

kayaba_say "「見事だ、剣士よ。君はメモリの荒野を抜け、ついにカーネルが管理するストレージの領域……\n  『外界回廊』へと足を踏み入れた」"
press_enter

clear_screen
show_banner

kayaba_say "「プログラムがメモリ上に展開された一時の夢であるならば、\n  ファイルとはディスクに刻まれる永続的な実体である」"
press_enter

clear_screen
show_banner

kayaba_say "「オペレーティングシステム（OS）と対話し、ファイルを開き、書き込み、ディレクトリを走査する。\n  外界回廊を統べるシステムコールの制御術を身につけたまえ」"
press_enter

# INTERACTIVE Q&A MENU LOOP
while true; do
    clear_screen
    show_banner
    kayaba_say "「何について知りたいのかね？ どの問いにも、この世界の真理をもって答えよう」"

    echo -e "${BOLD}【茅場教官への質問を選択せよ】${NC}"
    echo -e "  ${GREEN}1.${NC} ファイルを開く（fopen）ってOSの中で何が起きてるの？"
    echo -e "  ${GREEN}2.${NC} ディレクトリを走査する仕組み（opendir / readdir）ってどうなってるの？"
    echo -e "  ${GREEN}3.${NC} ファイルポインタの閉じ忘れ（fclose）はどう危険なの？"
    echo -e "  ${GREEN}4.${NC} 【疑問はすべて氷解した】第8層のミッションへ進む"
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
            kayaba_say "「fopen。ユーザープログラムが OS カーネルへ助けを求めるシステムコール呼び出しだな」"
            echo -e "${BOLD}■ 茅場教官の解説：OSがファイルディスクリプタを割り当て、ストリーム構造体を返す${NC}"
            echo -e "--------------------------------------------------"
            echo -e "C言語の fopen(\"file.txt\", \"r\") を実行すると、裏側で OS にアクセス要求が飛ぶ。"
            echo -e "OS はストレージ上のファイル実体を探し、権限をチェックした上で"
            echo -e "カーネル内部の『ファイルテーブル』にエントリを作成する。"
            echo -e ""
            echo -e "C標準ライブラリは、その番号（ファイルディスクリプタ）をラップした"
            echo -e "FILE 構造体へのポインタ (FILE *) を君に返してくれるのだ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        2)
            clear_screen
            show_banner
            kayaba_say "「ディレクトリ走査（opendir / readdir）。ツリー状のファイルシステムを巡回する術だ」"
            echo -e "${BOLD}■ 茅場教官の解説：ディレクトリも本質は『ファイルやフォルダの目録ファイル』${NC}"
            echo -e "--------------------------------------------------"
            echo -e "UNIX において『すべてのものはファイルである』。"
            echo -e "ディレクトリとは、そのフォルダ内に含まれるファイル名と inode 番号の一覧が書かれた特殊なファイルだ。"
            echo -e ""
            echo -e "・${GREEN}opendir(\"dir\")${NC} : ディレクトリ構造体 (DIR *) をオープンする。"
            echo -e "・${CYAN}readdir(dir)${NC} : 呼び出すたびに 1 エントリずつ struct dirent を返す。"
            echo -e "  エントリがなくなると NULL を返すため、while(ent = readdir(dir)) ループで走査する。"
            echo -e "・${YELLOW}closedir(dir)${NC} : 最後に必ず閉じなければリソース漏れとなる。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        3)
            clear_screen
            show_banner
            kayaba_say "「fclose の忘却。ファイルハンドルリークが引き起こすシステム麻痺だな」"
            echo -e "${BOLD}■ 茅場教官の解説：OSがプロセスごとに設定している『開けるファイル数の上限』${NC}"
            echo -e "--------------------------------------------------"
            echo -e "OS は 1 つのプロセスが開けるファイル記述子の数に制限（ulimit など）を設けている。"
            echo -e "fopen や opendir したまま fclose / closedir を怠ると、"
            echo -e "『Too many open files』エラーが発生し、二度とファイルを開けなくなる。"
            echo -e ""
            echo -e "さらに、バッファリングされたデータがディスクに書き出されない（flush されない）まま"
            echo -e "プログラムが終了し、ファイルが破損するリスクも生じるのだ。"
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

kayaba_say "「よし。ファイル I/O と Directory 走査の理は理解できたようだな。\n  では、第8層のクリーンアップツール作成ミッションに挑むがいい」"

echo -e "${BOLD}【第8層 ミッション指令書】${NC}"
echo -e "--------------------------------------------------"
echo -e "1. 'MISSION.md' を熟読し、ファイルやディレクトリ走査・クリーンアップ仕様を確認せよ。"
echo -e "2. エディタで 'Floor_08_OuterCorridor/cleaner.c' を開き、/* TODO */ を実装せよ。"
echo -e "3. 準備ができたら、自動採点スクリプト './test.sh' を実行してボスを撃破せよ。"
echo -e "--------------------------------------------------"
echo ""

kayaba_say "「君の健闘を祈る。ストレージの塵を払い、緑の『CLEARED!』を刻んでみせたまえ」"

echo -e "${BOLD}次のアクションを選択せよ:${NC}"
echo -e "  ${GREEN}1.${NC} 今すぐボス戦（./test.sh）に挑む"
echo -e "  ${GREEN}2.${NC} 終了してコード編集（cleaner.c）を開始する"
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
