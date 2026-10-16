#!/bin/bash
cd "$(dirname "$0")" || exit 1
source ../shared/test_helper.sh "$1"

sao_banner "10" "紅玉宮 (Ruby Palace - Final Test)"

SRC_FILE="main.c"
if [ "$USE_SOLUTION" -eq 1 ]; then
    SRC_FILE=".solution/main.c"
fi

# 1. コンパイルチェック (リリース最適化 -O2 指定)
gcc -std=c11 -O2 -Wall -Wextra -Werror -o floor_runner "$SRC_FILE" 2> compile_err.log
if [ $? -ne 0 ]; then
    cat compile_err.log
    rm -f compile_err.log
    sao_fail "コンパイルに失敗した。構文エラーや最適化オプション時の警告を見直したまえ。"
fi
rm -f compile_err.log
sao_pass "Test 1: リリース最適化ビルド (-O2 -Wall -Wextra -Werror) 成功"

# 2. 終了ステータスチェック
OUTPUT=$(./floor_runner)
RET_CODE=$?
if [ $RET_CODE -ne 0 ]; then
    rm -f floor_runner
    sao_fail "main関数の終了コードが 0 ではない (現在の返り値: ${RET_CODE})。"
fi
sao_pass "Test 2: 正常終了ステータス (return 0) を確認"

# 3. 出力内容の検証
SYSNAME=$(uname -s)

if ! echo "$OUTPUT" | grep -q "OS      : ${SYSNAME}"; then
    echo "--- 実際の出力 ---"
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "OS名 (${SYSNAME}) が正しく出力されていない。"
fi

if ! echo "$OUTPUT" | grep -q "STORAGE : .*% USED"; then
    echo "--- 実際の出力 ---"
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "STORAGEの使用率(%.1f%% USED)が正しく出力されていない。"
fi

if ! echo "$OUTPUT" | grep -q "RANK   : S \[MASTER OF KERNEL\]"; then
    echo "--- 実際の出力 ---"
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "クリア認定証の刻印 'RANK   : S [MASTER OF KERNEL]' が見つからない。"
fi

sao_pass "Test 3: OS情報・ストレージ情報・MASTER OF KERNEL 刻印の出力を検証"

rm -f floor_runner
sao_complete "Floor_10_RubyPalace"
