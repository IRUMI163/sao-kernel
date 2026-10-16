#!/bin/bash
cd "$(dirname "$0")" || exit 1
source ../shared/test_helper.sh "$1"

sao_banner "07" "記憶の断頭台 (The Guillotine of Memory)"

TARGET_IMPL="file_list.c"
if [ "$USE_SOLUTION" -eq 1 ]; then
    TARGET_IMPL=".solution/file_list.c"
fi

# 1. コンパイルチェック（-I../gear/include -fsanitize=address -g）
gcc -std=c11 -Wall -Wextra -Werror -I../gear/include -fsanitize=address -g -o floor_runner main.c "$TARGET_IMPL" 2> compile_err.log
if [ $? -ne 0 ]; then
    cat compile_err.log
    rm -f compile_err.log
    sao_fail "コンパイルに失敗した。構文エラーや警告を見直したまえ。"
fi
rm -f compile_err.log
sao_pass "Test 1: 厳格コンパイル (-Wall -Wextra -Werror -fsanitize=address) 成功"

# 2. 実行およびメモリチェック (AddressSanitizer)
OUTPUT=$(./floor_runner 2>&1)
RET_CODE=$?

if [ $RET_CODE -ne 0 ]; then
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "プログラムが異常終了した（返り値: ${RET_CODE}）。メモリ不具合や例外を点検せよ。"
fi
sao_pass "Test 2: 1,000件動的メモリ追加および正常終了を確認"

EXPECTED_SUBSTRING="Successfully added 1000 files."
if [[ "$OUTPUT" != *"$EXPECTED_SUBSTRING"* ]]; then
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "実行出力が期待された内容を含んでいない。"
fi
sao_pass "Test 3: 動的配列拡張と全データ整合性を確認"

rm -f floor_runner
sao_complete "Floor_07_Guillotine"
