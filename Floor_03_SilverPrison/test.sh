#!/bin/bash
cd "$(dirname "$0")" || exit 1
source ../shared/test_helper.sh "$1"

sao_banner "03" "白銀の牢獄 (Silver Prison)"

SRC_FILE="safe_str.c"
if [ "$USE_SOLUTION" -eq 1 ]; then
    SRC_FILE=".solution/safe_str.c"
fi

# 1. コンパイル＆ASanビルドチェック
gcc -std=c11 -Wall -Wextra -Werror -fsanitize=address -g -I. -o floor_runner main.c "$SRC_FILE" 2> compile_err.log
if [ $? -ne 0 ]; then
    cat compile_err.log
    rm -f compile_err.log
    sao_fail "コンパイルに失敗した。構文エラーや警告を見直したまえ。"
fi
rm -f compile_err.log
sao_pass "Test 1: 厳格コンパイル (-Wall -Wextra -Werror -fsanitize=address) 成功"

# 2. テスト harness 実行と AddressSanitizer チェック
OUTPUT=$(./floor_runner 2>&1)
RET_CODE=$?

if [ $RET_CODE -ne 0 ]; then
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "テストハーネスの実行に失敗した (終了コード: ${RET_CODE})。バッファオーバーフローやアサーション失敗を確認せよ。"
fi

if echo "$OUTPUT" | grep -q "AddressSanitizer"; then
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "AddressSanitizer エラーが検出された。メモリ破壊や境界外アクセスを見直したまえ。"
fi

sao_pass "Test 2: ASanエラー0件かつ全アサーション成功"

rm -f floor_runner
sao_complete "Floor_03_SilverPrison"
