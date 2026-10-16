#!/bin/bash
# ==============================================================================
# SAO: Kernel - Interactive RPG Story Engine (Floor 09)
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
    echo -e "${CYAN}  FLOOR 09 : 堅牢なる城壁 (The Iron Wall)${NC}"
    echo -e "${CYAN}==================================================${NC}"
    echo ""
}

# PROLOGUE
clear_screen
show_banner

kayaba_say "「ようこそ、第9層『堅牢なる城壁』へ。\n  これまでの君たちは、プログラムを『正常に動かすこと』に注力してきた」"
press_enter

clear_screen
show_banner

kayaba_say "「だが、現実のプログラミングにおいて真の優秀さを決定づけるのは、\n  予期せぬ異常やエラーに遭遇した時の『振る舞い』なのだ」"
press_enter

clear_screen
show_banner

kayaba_say "「標準出力（stdout）と標準エラー（stderr）の分離、そして errno によるシステムエラーハンドリング。\n  いかなる不測の事態にも折れぬ、鉄壁の堅牢性を手に入れるのだ」"
press_enter

# INTERACTIVE Q&A MENU LOOP
while true; do
    clear_screen
    show_banner
    kayaba_say "「何について知りたいのかね？ どの問いにも、この世界の真理をもって答えよう」"

    echo -e "${BOLD}【茅場教官への質問を選択せよ】${NC}"
    echo -e "  ${GREEN}1.${NC} なんで正常出力（stdout）とエラー（stderr）をわざわざ分けるの？"
    echo -e "  ${GREEN}2.${NC} 『errno』ってどこから飛んでくるエラー番号なの？"
    echo -e "  ${GREEN}3.${NC} 終了ステータス（exit status）で 0 以外を返す意味とは？"
    echo -e "  ${GREEN}4.${NC} 【疑問はすべて氷解した】第9層のミッションへ進む"
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
            kayaba_say "「stdout と stderr の分離。UNIX 哲学が生み出したパイプライン処理の要だな」"
            echo -e "${BOLD}■ 茅場教官の解説：計算結果データと警告・ログ出力を別々の流路に分離する${NC}"
            echo -e "--------------------------------------------------"
            echo -e "CLI ツールは 'command | grep foo > result.txt' のように"
            echo -e "別のプログラムへ出力を流し込む（パイプライン結合する）。"
            echo -e ""
            echo -e "もしエラーメッセージを標準出力（stdout）に流してしまうと、"
            echo -e "後続のコマンドが『エラー文字列もデータの一部』と勘違いして破壊される。"
            echo -e "データ処理用の ${GREEN}stdout (fd: 1)${NC} と、人間への警告通知用の ${RED}stderr (fd: 2)${NC} を"
            echo -e "明確に区別して出力するのがプロのプロダクトの流儀だ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        2)
            clear_screen
            show_banner
            kayaba_say "「errno。C標準ライブラリや OS システムコールが失敗原因を告げる声だ」"
            echo -e "${BOLD}■ 茅場教官の解説：<errno.h> に定義されたグローバル/スレッドローカル変数${NC}"
            echo -e "--------------------------------------------------"
            echo -e "fopen や read などのシステム関数が失敗した（NULL や -1 を返した）時、"
            echo -e "OS は何が原因かを errno という整数変数に書き込む。"
            echo -e ""
            echo -e "例えば ENOENT (2) は『ファイルが存在しない』、EACCES (13) は『アクセス権限がない』を表す。"
            echo -e "'strerror(errno)' や 'perror(\"Error\")' を使うことで、"
            echo -e "人間が読めるエラーメッセージ文字列に変換して stderr へ出力できるのだ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        3)
            clear_screen
            show_banner
            kayaba_say "「終了ステータス（Exit Status）。親プロセス（シェル）へ送信する成否の合図だ」"
            echo -e "${BOLD}■ 茅場教官の解説：成功なら 0、失敗なら 1 以上のエラーコードを返却する規約${NC}"
            echo -e "--------------------------------------------------"
            echo -e "シェルスクリプトや CI/CD 自動テスト環境では、"
            echo -e "前回のコマンドが成功したか（'return 0;' / 'exit(0);'）を見て"
            echo -e "次のステップへ進むかを判断している（$? で確認可能）。"
            echo -e ""
            echo -e "エラーが発生したにもかかわらず 0 を返したり、逆に成功したのに 1 を返すと"
            echo -e "自動化システムが狂い、壊滅的な誤動作を引き起こす。"
            echo -e "厳格な終了ステータスの制御こそ、鉄壁のプログラムの証なのだ。"
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

kayaba_say "「よし。エラーハンドリングと UNIX 思想の理は理解できたようだな。\n  では、第9層の堅牢性検証ミッションに挑戦したまえ」"

echo -e "${BOLD}【第9層 ミッション指令書】${NC}"
echo -e "--------------------------------------------------"
echo -e "1. 'MISSION.md' を熟読し、エラーハンドリングと標準エラー出力（stderr）へのメッセージ出力仕様を確認せよ。"
echo -e "2. エディタで 'Floor_09_IronWall/main.c' を開き、/* TODO */ を実装せよ。"
echo -e "3. 準備ができたら、自動採点スクリプト './test.sh' を実行してボスを撃破せよ。"
echo -e "--------------------------------------------------"
echo ""

kayaba_say "「君の健闘を祈る。城壁を築き上げ、緑の『CLEARED!』を刻んでみせたまえ」"

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
