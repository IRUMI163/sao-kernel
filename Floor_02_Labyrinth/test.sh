#!/bin/bash
cd "$(dirname "$0")" || exit 1
source ../shared/test_helper.sh "$1"

sao_banner "02" "迷いの森 (The Labyrinth)"

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

# 2. 引数なしチェック
OUTPUT=$(./floor_runner)
RET_CODE=$?
if [ $RET_CODE -ne 1 ]; then
    rm -f floor_runner
    sao_fail "引数なしの時の終了コードが 1 ではない (返り値: ${RET_CODE})"
fi
EXPECTED="[ERROR] NO COMMAND SPECIFIED"
if [ "$OUTPUT" != "$EXPECTED" ]; then
    echo "--- 期待される出力 ---"
    echo "$EXPECTED"
    echo "--- 実際の出力 ---"
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "引数なしの時の出力メッセージが仕様と一致しない。"
fi
sao_pass "Test 2: 引数なし ([ERROR] NO COMMAND SPECIFIED / exit 1) 成功"

# 3. -h オプションチェック
OUTPUT=$(./floor_runner -h)
RET_CODE=$?
if [ $RET_CODE -ne 0 ]; then
    rm -f floor_runner
    sao_fail "-h オプション実行時の終了コードが 0 ではない (返り値: ${RET_CODE})"
fi
EXPECTED="USAGE: gear <stat|memo|clean> [options]"
if [ "$OUTPUT" != "$EXPECTED" ]; then
    echo "--- 期待される出力 ---"
    echo "$EXPECTED"
    echo "--- 実際の出力 ---"
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "-h オプション実行時の出力メッセージが仕様と一致しない。"
fi
sao_pass "Test 3: -h オプション (USAGE: ... / exit 0) 成功"

# 4. -v オプションチェック
OUTPUT=$(./floor_runner -v)
RET_CODE=$?
if [ $RET_CODE -ne 0 ]; then
    rm -f floor_runner
    sao_fail "-v オプション実行時の終了コードが 0 ではない (返り値: ${RET_CODE})"
fi
EXPECTED="GEAR VERSION 1.0.0-aincrad"
if [ "$OUTPUT" != "$EXPECTED" ]; then
    echo "--- 期待される出力 ---"
    echo "$EXPECTED"
    echo "--- 実際の出力 ---"
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "-v オプション実行時の出力メッセージが仕様と一致しない。"
fi
sao_pass "Test 4: -v オプション (GEAR VERSION 1.0.0-aincrad / exit 0) 成功"

# 5. memo コマンドチェック（正常系）
OUTPUT=$(./floor_runner memo hello world sword art)
RET_CODE=$?
if [ $RET_CODE -ne 0 ]; then
    rm -f floor_runner
    sao_fail "memo コマンド実行時の終了コードが 0 ではない (返り値: ${RET_CODE})"
fi
EXPECTED="MEMO: hello world sword art"
if [ "$OUTPUT" != "$EXPECTED" ]; then
    echo "--- 期待される出力 ---"
    echo "$EXPECTED"
    echo "--- 実際の出力 ---"
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "memo コマンド実行時の出力メッセージが仕様と一致しない。"
fi
sao_pass "Test 5: memo コマンド (MEMO: hello world sword art / exit 0) 成功"

# 6. memo コマンドチェック（引数なしエラー系）
OUTPUT=$(./floor_runner memo)
RET_CODE=$?
if [ $RET_CODE -ne 1 ]; then
    rm -f floor_runner
    sao_fail "空の memo コマンド実行時の終了コードが 1 ではない (返り値: ${RET_CODE})"
fi
EXPECTED="[ERROR] EMPTY MEMO"
if [ "$OUTPUT" != "$EXPECTED" ]; then
    echo "--- 期待される出力 ---"
    echo "$EXPECTED"
    echo "--- 実際の出力 ---"
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "空の memo コマンド実行時の出力メッセージが仕様と一致しない。"
fi
sao_pass "Test 6: memo 空引数 ([ERROR] EMPTY MEMO / exit 1) 成功"

# 7. 未知のコマンドチェック
OUTPUT=$(./floor_runner unknown_cmd)
RET_CODE=$?
if [ $RET_CODE -ne 1 ]; then
    rm -f floor_runner
    sao_fail "未知のコマンド実行時の終了コードが 1 ではない (返り値: ${RET_CODE})"
fi
EXPECTED="[ERROR] UNKNOWN COMMAND: unknown_cmd"
if [ "$OUTPUT" != "$EXPECTED" ]; then
    echo "--- 期待される出力 ---"
    echo "$EXPECTED"
    echo "--- 実際の出力 ---"
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "未知のコマンド実行時の出力メッセージが仕様と一致しない。"
fi
sao_pass "Test 7: 未知のコマンド ([ERROR] UNKNOWN COMMAND: ... / exit 1) 成功"

rm -f floor_runner
sao_complete "Floor_02_Labyrinth"
