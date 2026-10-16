#!/bin/bash
cd "$(dirname "$0")" || exit 1
source ../shared/test_helper.sh "$1"

sao_banner "05" "最深の深淵（中間試験） (The Deepest Abyss)"

SRC_FILE="main.c"
if [ "$USE_SOLUTION" -eq 1 ]; then
    SRC_FILE=".solution/main.c"
fi

# 1. コンパイルチェック（ASan 有効化）
gcc -std=c11 -Wall -Wextra -Werror -fsanitize=address -g -o floor_runner "$SRC_FILE" 2> compile_err.log
if [ $? -ne 0 ]; then
    cat compile_err.log
    rm -f compile_err.log
    sao_fail "コンパイルに失敗した。構文エラーや型不一致を見直したまえ。"
fi
rm -f compile_err.log
sao_pass "Test 1: 厳格コンパイル & ASan (-Wall -Wextra -Werror -fsanitize=address) 成功"

# 2. 実行 & 出力チェック
OUTPUT=$(./floor_runner 2>&1)
RET_CODE=$?

if [ $RET_CODE -ne 0 ]; then
    rm -f floor_runner
    sao_fail "プログラムが異常終了した (クラッシュ/セグフォ/ASan違反)。クラッシュログを確認せよ:\n$OUTPUT"
fi
sao_pass "Test 2: クラッシュなしで正常終了ステータス (return 0) を確認"

# 3. 期待される出力の検証
EXPECTED="==================================================
  [AINCRAD SYSTEM] : FLOOR 05 EXAM - ABYSS
==================================================
[TEST 1] Pass-by-Pointer Check
  Before: Level 1
  After : Level 2 (SUCCESS)

[TEST 2] NULL Pointer Guard Check
  Valid HP Read: 250
  NULL HP Read : -1 (SUCCESS)

[TEST 3] Array Boundary Check
  Array Elements: 10 20 30 40 50
  Boundary Check: PASSED (SUCCESS)
==================================================
ALL TESTS PASSED! YOU SURVIVED THE ABYSS.
=================================================="

if [ "$OUTPUT" != "$EXPECTED" ]; then
    echo "--- 期待される出力 ---"
    echo "$EXPECTED"
    echo "--- 実際の出力 ---"
    echo "$OUTPUT"
    rm -f floor_runner
    sao_fail "出力内容が不一致、またはバグが未修正である。"
fi
sao_pass "Test 3: 全テスト項目パス & 出力フォーマット完全一致"

rm -f floor_runner
sao_complete "Floor_05_Abyss"
