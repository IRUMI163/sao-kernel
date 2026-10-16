#!/bin/bash
cd "$(dirname "$0")" || exit 1
source ../shared/test_helper.sh "$1"

sao_banner "04" "迷宮区の製図室 (The Drafting Room)"

TARGET_HEADER="calc.h"
TARGET_DIR="."
if [ "$USE_SOLUTION" -eq 1 ]; then
    TARGET_HEADER=".solution/calc.h"
    TARGET_DIR=".solution"
fi

# 1. ヘッダファイルのインクルードガード検査 (#ifndef ディレクティブが存在するか)
if ! grep -E '^[[:space:]]*#ifndef' "$TARGET_HEADER" > /dev/null 2>&1; then
    sao_fail "calc.h に #ifndef インクルードガードが記述されていない。"
fi
sao_pass "Test 1: ヘッダファイル (calc.h) のインクルードガード記述を確認"

# 2. make ビルド検証
if [ "$USE_SOLUTION" -eq 1 ]; then
    # Solution モード時は .solution 内の Makefile / calc.h / calc.c と main.c を一時的にコピーしてビルド
    cp main.c .solution/
    make -C .solution clean > /dev/null 2>&1
    make -C .solution > compile_err.log 2>&1
    BUILD_RET=$?
    rm -f .solution/main.c
else
    make clean > /dev/null 2>&1
    make > compile_err.log 2>&1
    BUILD_RET=$?
fi

if [ $BUILD_RET -ne 0 ]; then
    cat compile_err.log
    rm -f compile_err.log
    sao_fail "make コマンドでのビルドに失敗した。Makefile やソースコードを見直したまえ。"
fi
rm -f compile_err.log
sao_pass "Test 2: make コマンドによるビルド成功"

RUNNER="${TARGET_DIR}/floor_runner"
if [ ! -f "$RUNNER" ]; then
    sao_fail "ビルド成果物 'floor_runner' が生成されていない。"
fi

# 3. 実行および出力結果フォーマット検証
OUTPUT=$("$RUNNER")
RET_CODE=$?

# クリーンアップ
if [ "$USE_SOLUTION" -eq 1 ]; then
    make -C .solution clean > /dev/null 2>&1
else
    make clean > /dev/null 2>&1
fi

if [ $RET_CODE -ne 0 ]; then
    sao_fail "floor_runner の終了コードが 0 ではない (現在の返り値: ${RET_CODE})。"
fi
sao_pass "Test 3: 正常終了ステータス (return 0) を確認"

EXPECTED="==================================================
  [AINCRAD SYSTEM] : DRAFTING ROOM MODULE
==================================================
STORAGE USAGE : 42%
PLAYER SCORE  : 750 (RANK: 2)
=================================================="

if [ "$OUTPUT" != "$EXPECTED" ]; then
    echo "--- 期待される出力 ---"
    echo "$EXPECTED"
    echo "--- 実際の出力 ---"
    echo "$OUTPUT"
    sao_fail "出力結果が期待値と一致しない。"
fi
sao_pass "Test 4: 計算結果および出力フォーマット完全一致"

sao_complete "Floor_04_DraftingRoom"
