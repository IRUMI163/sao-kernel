#!/bin/bash
cd "$(dirname "$0")" || exit 1
source ../shared/test_helper.sh "$1"

sao_banner "06" "魂の設計図 (Soul Blueprint)"

ARG_PARSER_SRC="arg_parser.c"
if [ "$USE_SOLUTION" -eq 1 ]; then
    ARG_PARSER_SRC=".solution/arg_parser.c"
fi

# 1. コンパイルチェック (ASan & 厳格ビルド)
gcc -std=c11 -Wall -Wextra -Werror -fsanitize=address -I../gear/include -o floor_runner main.c "$ARG_PARSER_SRC" 2> compile_err.log
if [ $? -ne 0 ]; then
    cat compile_err.log
    rm -f compile_err.log
    sao_fail "コンパイルに失敗した。構文エラーや型チェックを見直したまえ。"
fi
rm -f compile_err.log
sao_pass "Test 1: 厳格コンパイル (-Wall -Wextra -Werror -fsanitize=address -I../gear/include) 成功"

# 2. 単体テスト実行チェック
OUTPUT=$(./floor_runner 2>&1)
RET_CODE=$?

if [ $RET_CODE -ne 0 ]; then
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "引数解析テストが失敗した。parse_args の実装を見直したまえ。"
fi

if ! echo "$OUTPUT" | grep -q "ALL_PATTERNS_PASSED"; then
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "全テストパターンの検証を通過できなかった。"
fi

sao_pass "Test 2: 全 6 パターンのコマンドライン引数解析単体テストに合格"

rm -f floor_runner
sao_complete "Floor_06_SoulBlueprint"
