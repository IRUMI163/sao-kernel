#!/bin/bash
cd "$(dirname "$0")" || exit 1
source ../shared/test_helper.sh "$1"

sao_banner "01" "転移門広場 (The Gate of Aincrad)"

SRC_FILE="main.c"
if [ "$USE_SOLUTION" -eq 1 ]; then
    SRC_FILE=".solution/main.c"
fi

# 1. コンパイルチェック
gcc -std=c11 -Wall -Wextra -Werror -o floor_runner "$SRC_FILE" 2> compile_err.log
if [ $? -ne 0 ]; then
    cat compile_err.log
    rm -f compile_err.log
    sao_fail "コンパイルに失敗した。構文エラーや警告（未使用変数など）を見直したまえ。"
fi
rm -f compile_err.log
sao_pass "Test 1: 厳格コンパイル (-Wall -Wextra -Werror) 成功"

# 2. 終了ステータスチェック
OUTPUT=$(./floor_runner)
RET_CODE=$?
if [ $RET_CODE -ne 0 ]; then
    rm -f floor_runner
    sao_fail "main関数の終了コードが 0 ではない (現在の返り値: ${RET_CODE})。"
fi
sao_pass "Test 2: 正常終了ステータス (return 0) を確認"

# 3. 出力フォーマット完全一致チェック
EXPECTED="==================================================
  [AINCRAD SYSTEM] : STATUS WINDOW
==================================================
PLAYER : KIRITO
LEVEL  : 0001
HP     : 0250 / 0250
STORAGE: 42.5% USED
=================================================="

if [ "$OUTPUT" != "$EXPECTED" ]; then
    echo "--- 期待される出力 ---"
    echo "$EXPECTED"
    echo "--- 実際の出力 ---"
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "出力フォーマットが仕様と一致しない。スペースの数やゼロ埋め桁数を確認せよ。"
fi
sao_pass "Test 3: ステータスウィンドウ出力フォーマット完全一致"

rm -f floor_runner
sao_complete "Floor_01_Gate"
