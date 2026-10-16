#!/bin/bash
cd "$(dirname "$0")" || exit 1
source ../shared/test_helper.sh "$1"

sao_banner "08" "外界回廊 (The Outer Corridor)"

CLEANER_SRC="cleaner.c"
if [ "$USE_SOLUTION" -eq 1 ]; then
    CLEANER_SRC=".solution/cleaner.c"
fi

# 1. コンパイルチェック
gcc -std=c11 -Wall -Wextra -Werror -o floor_runner main.c "$CLEANER_SRC" 2> compile_err.log
if [ $? -ne 0 ]; then
    cat compile_err.log
    rm -f compile_err.log
    sao_fail "コンパイルに失敗した。構文エラーや警告を見直したまえ。"
fi
rm -f compile_err.log
sao_pass "Test 1: 厳格コンパイル (-Wall -Wextra -Werror) 成功"

# 2. サンドボックス環境セットアップ
./setup_sandbox.sh > /dev/null 2>&1
if [ ! -d "./dungeon_box" ]; then
    rm -f floor_runner
    sao_fail "setup_sandbox.sh による ./dungeon_box の作成に失敗した。"
fi
sao_pass "Test 2: サンドボックス環境の初期化成功"

# 3. dry_run = 1 (シミュレーション) 検証
OUTPUT_DRY=$(./floor_runner ./dungeon_box --dry-run)
RET_CODE=$?
if [ $RET_CODE -ne 0 ]; then
    rm -f floor_runner
    rm -rf ./dungeon_box
    sao_fail "dry_run 実行時の終了コードが 0 ではない (現在の返り値: ${RET_CODE})。"
fi

# dry_run ではファイルが移動せず、全7ファイルが直下に残っていることを確認
COUNT_DRY=$(ls -1 ./dungeon_box | grep -v '^\.' | wc -l)
if [ "$COUNT_DRY" -ne 7 ]; then
    rm -f floor_runner
    rm -rf ./dungeon_box
    sao_fail "dry_run モードにもかかわらずファイルが移動または削除された (直下残数: ${COUNT_DRY}, 期待値: 7)。"
fi
sao_pass "Test 3: dry_run モードでファイルが移動しないことを確認 (7件検出)"

# 4. dry_run = 0 (実際整理) 検証
OUTPUT_REAL=$(./floor_runner ./dungeon_box)
RET_CODE=$?
if [ $RET_CODE -ne 0 ]; then
    rm -f floor_runner
    rm -rf ./dungeon_box
    sao_fail "整理実行時の終了コードが 0 ではない (現在の返り値: ${RET_CODE})。"
fi

# サブディレクトリと移動状況の検証
# Images: map.png, avatar.jpg
# Docs: quest.pdf, readme.txt
# Code: kernel.c
# Archives: backup.zip
# Others: mystery.dat
# .hidden_key は ./dungeon_box 直下に残る

if [ ! -f "./dungeon_box/Images/map.png" ] || [ ! -f "./dungeon_box/Images/avatar.jpg" ]; then
    rm -f floor_runner
    rm -rf ./dungeon_box
    sao_fail "Images フォルダへのファイル振り分け失敗。"
fi

if [ ! -f "./dungeon_box/Docs/quest.pdf" ] || [ ! -f "./dungeon_box/Docs/readme.txt" ]; then
    rm -f floor_runner
    rm -rf ./dungeon_box
    sao_fail "Docs フォルダへのファイル振り分け失敗。"
fi

if [ ! -f "./dungeon_box/Code/kernel.c" ]; then
    rm -f floor_runner
    rm -rf ./dungeon_box
    sao_fail "Code フォルダへのファイル振り分け失敗。"
fi

if [ ! -f "./dungeon_box/Archives/backup.zip" ]; then
    rm -f floor_runner
    rm -rf ./dungeon_box
    sao_fail "Archives フォルダへのファイル振り分け失敗。"
fi

if [ ! -f "./dungeon_box/Others/mystery.dat" ]; then
    rm -f floor_runner
    rm -rf ./dungeon_box
    sao_fail "Others フォルダへのファイル振り分け失敗。"
fi

if [ ! -f "./dungeon_box/.hidden_key" ]; then
    rm -f floor_runner
    rm -rf ./dungeon_box
    sao_fail "隠しファイル .hidden_key が消失した。"
fi

sao_pass "Test 4: 拡張子別サブフォルダへの正確なファイル振り分けおよび隠しファイルの維持を確認"

# 後片付け
rm -f floor_runner
rm -rf ./dungeon_box

sao_complete "Floor_08_OuterCorridor"
