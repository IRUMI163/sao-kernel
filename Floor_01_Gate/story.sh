#!/bin/bash
# ==============================================================================
# SAO: Kernel - Interactive RPG Story Engine (Floor 01 Golden Sample)
# Character: Akihiko Kayaba (Heathcliff)
# ==============================================================================

CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
MAGENTA='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# 画面クリア関数
clear_screen() {
    clear 2>/dev/null || echo -e "\n--------------------------------------------------"
}

# キー入力待ち関数（パイプや自動テスト時も考慮）
press_enter() {
    echo -e "${YELLOW}[ ⏎ Enterキーを押して次へ進む... ]${NC}"
    if [ -t 0 ]; then
        read -r _
    else
        read -r _ 2>/dev/null || true
    fi
}

# 茅場晶彦のセリフ表示関数
kayaba_say() {
    echo -e "${CYAN}${BOLD}【茅場晶彦】${NC}"
    echo -e "$1"
    echo ""
}

# システムバナー表示
show_banner() {
    echo -e "${CYAN}==================================================${NC}"
    echo -e "${CYAN}  SWORD ART ONLINE : KERNEL - STORY MODE${NC}"
    echo -e "${CYAN}  FLOOR 01 : 転移門広場 (The Gate of Aincrad)${NC}"
    echo -e "${CYAN}==================================================${NC}"
    echo ""
}

# ==============================================================================
# PROLOGUE
# ==============================================================================
clear_screen
show_banner

kayaba_say "「ようこそ、電脳の最下層へ。\n  プレイヤー諸君、君たちの旅はここから始まる」"
press_enter

clear_screen
show_banner

kayaba_say "「目の前の『黒い画面（ターミナル）』を恐れる必要はない。\n  アイコンをクリックするだけの受動的な世界に別れを告げ、\n  自らの言葉（コード）を機械語へとコンパイルし、\n  このアインクラッドに君自身の存在を刻み込むのだ」"
press_enter

clear_screen
show_banner

kayaba_say "「だが――焦ることはない。\n  未熟な知識のまま武器（キーボード）を振るえば、メモリの暴走によって自滅するのみ。\n  まずは、君の胸中にある疑問を私にぶつけてみたまえ」"
press_enter

# ==============================================================================
# INTERACTIVE Q&A MENU LOOP
# ==============================================================================
while true; do
    clear_screen
    show_banner
    kayaba_say "「何について知りたいのかね？ どの問いにも、この世界の真理をもって答えよう」"

    echo -e "${BOLD}【茅場教官への質問を選択せよ】${NC}"
    echo -e "  ${GREEN}1.${NC} 『変数』って何ですか？ 普通の文字や数字とどう違うの？"
    echo -e "  ${GREEN}2.${NC} 『コンパイル』って、人間が書いたコードをどうやって機械語にしてるの？"
    echo -e "  ${GREEN}3.${NC} 『フォーマット指定子（%04d等）』ってなんでわざわざ書く必要があるの？"
    echo -e "  ${GREEN}4.${NC} 『printf』って具体的にどう書くの？ 穴埋めパズルのルールを教えて"
    echo -e "  ${GREEN}5.${NC} 【疑問はすべて氷解した】第1層のミッションへ進む"
    echo ""
    echo -n -e "${YELLOW}選択肢を入力 (1-5): ${NC}"
    
    if [ -t 0 ]; then
        read -r choice
    else
        read -r choice 2>/dev/null || choice="5"
    fi

    case "$choice" in
        1)
            clear_screen
            show_banner
            kayaba_say "「ほう……『変数』の本質か。良い着眼点だ」"
            echo -e "${BOLD}■ 茅場教官の解説：変数は『メモリ上のロッカーの名前』である${NC}"
            echo -e "--------------------------------------------------"
            echo -e "コンピュータにとって、すべてのデータは広大な半導体メモリ（RAM）の中にあります。"
            echo -e "メモリには膨大な部屋番号（番地・メモリアドレス）が割り振られている。"
            echo -e ""
            echo -e "だが人間が「0x7ffee4b2 番地にHP 250を入れろ」と管理するのは不可能だ。"
            echo -e "そこで、その部屋（ロッカー）に分かりやすい名前のラベルを貼る。"
            echo -e "それが${GREEN}『変数（Variable）』${NC}だ。"
            echo -e ""
            echo -e "さらにC言語では、その箱が『整数用（int: 4バイト）』なのか、"
            echo -e "『小数用（double: 8バイト）』なのかを厳格に指定しなければならない。"
            echo -e "学マスで例えるなら、アイドルのVo・Da・Viのパラメータスロットを"
            echo -e "寸分の狂いもなく設計する行為と同じだ。型を曖昧にしては一流のプロデュースはできんよ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        2)
            clear_screen
            show_banner
            kayaba_say "「『コンパイル』かね。まさにプログラミングの核心だな」"
            echo -e "${BOLD}■ 茅場教官の解説：CPUは『0と1』の電気信号しか理解しない${NC}"
            echo -e "--------------------------------------------------"
            echo -e "君たちが書く '#include <stdio.h>' や 'printf' は、所詮人間が読みやすい"
            echo -e "アルファベットの羅列にすぎない。CPU（電子回路）には1文字たりとも通じないのだ。"
            echo -e ""
            echo -e "CPUが直接理解できるのは、高電圧と低電圧——すなわち『0と1の機械語（バイナリ）』のみ。"
            echo -e "人間が書いたソースコード（.cファイル）を解析し、無駄を削ぎ落とし、"
            echo -e "CPUが超高速で実行できる純粋な機械語に翻訳・結合する工程。"
            echo -e "それこそが${CYAN}『コンパイル（gcc / clang）』${NC}だ。"
            echo -e ""
            echo -e "Pythonなどのインタプリタ言語が1行ずつ通訳を雇って会話するのに対し、"
            echo -e "C言語はあらかじめ全編を完全翻訳した戦闘マニュアル（実行バイナリ）を生成する。"
            echo -e "だからこそ、C言語は0.001秒の遅延すら許されないOSカーネルやゲームエンジンで"
            echo -e "君臨し続けているのだよ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        3)
            clear_screen
            show_banner
            kayaba_say "「フォーマット指定子か。初心者が最も軽視し、そして最も痛い目を見る罠だ」"
            echo -e "${BOLD}■ 茅場教官の解説：メモリの生データを人間界へ『現送（レンダリング）』する規約${NC}"
            echo -e "--------------------------------------------------"
            echo -e "メモリの中にある数値 250 は、バイナリでは単なるビット列 '00000000 11111010' だ。"
            echo -e "'printf' 関数はこのビット列を見ただけでは、それが文字なのか、整数なのか、"
            echo -e "それともポインタアドレスなのかを判断できない。"
            echo -e ""
            echo -e "だから君自身が『これは整数として扱え (%d)』『文字列として展開せよ (%s)』と"
            echo -e "指示（フォーマット指定子）を出さねばならんのだ。"
            echo -e ""
            echo -e "さらに、今回課している '%04d' や '%.1f%%' を見てみたまえ。"
            echo -e "UI画面の桁数がガタガタに崩れたステータスウィンドウなど、プロのプロダクトとは呼べん。"
            echo -e "4桁でゼロ埋め（0001）し、小数を美しく揃える。"
            echo -e "細部への美意識なきエンジニアに、アインクラッドの深層を開く資格はない。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        4)
            clear_screen
            show_banner
            kayaba_say "「printf の具体的な書き方だな。よろしい、耳をかっぽじって聞きたまえ」"
            echo -e "${BOLD}■ 茅場教官の解説：printf は『穴埋めパズル』である${NC}"
            echo -e "--------------------------------------------------"
            echo -e "printf の基本構文はいたって単純だ。"
            echo -e ""
            echo -e "  ${GREEN}printf(\"テンプレート文章 %指定子\\\\n\", 変数名);${NC}"
            echo -e ""
            echo -e "例えば、プレイヤー名を出したいならこう書く："
            echo -e "  ${CYAN}printf(\"PLAYER : %s\\\\n\", player_name);${NC}"
            echo -e ""
            echo -e "ダブルクォーテーションの中にある '%s' の場所に、カンマの後ろにある"
            echo -e "'player_name'（中身は \"KIRITO\"）がスポッと代入されるのだ。"
            echo -e "そして最後の '\\\\n' は『改行せよ』という命令だ。これを忘れると次の行と横にくっついてしまう。"
            echo -e ""
            echo -e "もし変数を2つ埋め込みたいなら、穴を2つ開けて、後ろにも変数を2つ並べる："
            echo -e "  ${CYAN}printf(\"HP     : %04d / %04d\\\\n\", hp_current, hp_max);${NC}"
            echo -e ""
            echo -e "これだけだ。何も恐れることはない。穴の形（%sや%04d）を合わせ、変数をはめるだけだ。"
            echo -e "--------------------------------------------------"
            press_enter
            ;;
        5)
            break
            ;;
        *)
            echo -e "${RED}[SYSTEM ERROR] 1から5の番号を入力したまえ。${NC}"
            sleep 1
            ;;
    esac
done

# ==============================================================================
# EPILOGUE & MISSION BRIEFING
# ==============================================================================
clear_screen
show_banner

kayaba_say "「よし。基礎の理（ことわり）は頭に入ったようだな。\n  では、いよいよ最初の試練だ」"

echo -e "${BOLD}【第1層 ミッション指令書】${NC}"
echo -e "--------------------------------------------------"
echo -e "1. 'MISSION.md' を熟読し、要求される出力フォーマット（寸分のズレも許されぬ6行）を確認せよ。"
echo -e "2. エディタで 'Floor_01_Gate/main.c' を開き、/* TODO */ を実装せよ。"
echo -e "   （MISSION.md に写経できるサンプルコードを載せてある。真似して書いてみたまえ）"
echo -e "3. 準備ができたら、自動採点スクリプト './test.sh' を実行してボスを撃破せよ。"
echo -e "--------------------------------------------------"
echo ""

kayaba_say "「君の健闘を祈る。転移門広場のボスを撃破し、緑の『CLEARED!』を刻んでみせたまえ」"

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
