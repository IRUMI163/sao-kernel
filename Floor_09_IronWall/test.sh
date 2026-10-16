#!/bin/bash
cd "$(dirname "$0")" || exit 1
source ../shared/test_helper.sh "$1"

sao_banner "09" "堅牢なる城壁 (The Iron Wall)"

SRC_FILE="main.c"
if [ "$USE_SOLUTION" -eq 1 ]; then
    SRC_FILE=".solution/main.c"
fi

# 一時ファイルのクリーンアップ関数
cleanup() {
    rm -f floor_runner compile_err.log stdout.log stderr.log test_sample.txt no_perm.txt
}
trap cleanup EXIT

# 1. コンパイルチェック
gcc -std=c11 -Wall -Wextra -Werror -o floor_runner "$SRC_FILE" 2> compile_err.log
if [ $? -ne 0 ]; then
    cat compile_err.log
    sao_fail "コンパイルに失敗した。構文エラーや警告を見直したまえ。"
fi
sao_pass "Test 1: 厳格コンパイル (-Wall -Wextra -Werror) 成功"

# テスト2: 正常ファイルの行数カウント (Pattern 1)
printf "Line 1\nLine 2\nLine 3\n" > test_sample.txt
./floor_runner test_sample.txt 1> stdout.log 2> stderr.log
RET_CODE=$?

if [ $RET_CODE -ne 0 ]; then
    sao_fail "正常ファイル指定時の終了コードが 0 ではない (返り値: ${RET_CODE})。"
fi

STDOUT_OUT=$(cat stdout.log)
if [ "$STDOUT_OUT" != "LINES: 3" ]; then
    echo "--- 実際の stdout ---"
    echo "$STDOUT_OUT"
    sao_fail "正常ファイル指定時の stdout 出力が 'LINES: 3' と一致しない。"
fi

if [ -s stderr.log ]; then
    echo "--- 実際の stderr ---"
    cat stderr.log
    sao_fail "正常処理時に stderr へ不要な出力がされている。"
fi
sao_pass "Pattern 1: 正常ファイル行数カウント (stdout: 'LINES: 3', exit: 0, stderr: 空) 成功"

# テスト3: 引数なしエラー (Pattern 2)
./floor_runner 1> stdout.log 2> stderr.log
RET_CODE=$?

if [ $RET_CODE -ne 1 ]; then
    sao_fail "引数なし時の終了コードが 1 ではない (返り値: ${RET_CODE})。"
fi

if [ -s stdout.log ]; then
    sao_fail "引数なしエラー時に stdout へ不要な出力がされている。"
fi

STDERR_OUT=$(cat stderr.log)
if [[ "$STDERR_OUT" != *"[USAGE ERROR] File path required"* ]]; then
    echo "--- 実際の stderr ---"
    echo "$STDERR_OUT"
    sao_fail "引数なしエラー時の stderr メッセージが仕様と異なる。"
fi
sao_pass "Pattern 2: 引数なし異常系 (stderr: '[USAGE ERROR] File path required', exit: 1) 成功"

# テスト4: 存在しないファイル (Pattern 3)
./floor_runner nonexistent_file_xyz.txt 1> stdout.log 2> stderr.log
RET_CODE=$?

if [ $RET_CODE -ne 2 ]; then
    sao_fail "存在しないファイル指定時の終了コードが 2 ではない (返り値: ${RET_CODE})。"
fi

if [ -s stdout.log ]; then
    sao_fail "存在しないファイル指定時に stdout へ不要な出力がされている。"
fi

STDERR_OUT=$(cat stderr.log)
if [[ "$STDERR_OUT" != *"[IO ERROR]"* ]]; then
    echo "--- 実際の stderr ---"
    echo "$STDERR_OUT"
    sao_fail "存在しないファイル指定時の stderr メッセージに '[IO ERROR]' が含まれていない。"
fi
sao_pass "Pattern 3: 存在しないファイル異常系 (stderr: '[IO ERROR] ...', exit: 2) 成功"

# テスト5: ディレクトリ指定エラー (Pattern 4)
./floor_runner . 1> stdout.log 2> stderr.log
RET_CODE=$?

if [ $RET_CODE -ne 2 ]; then
    sao_fail "ディレクトリ指定時の終了コードが 2 ではない (返り値: ${RET_CODE})。"
fi

if [ -s stdout.log ]; then
    sao_fail "ディレクトリ指定時に stdout へ不要な出力がされている。"
fi

STDERR_OUT=$(cat stderr.log)
if [[ "$STDERR_OUT" != *"[IO ERROR] Target is a directory"* ]]; then
    echo "--- 実際の stderr ---"
    echo "$STDERR_OUT"
    sao_fail "ディレクトリ指定時の stderr メッセージが '[IO ERROR] Target is a directory' と一致しない。"
fi
sao_pass "Pattern 4: ディレクトリ指定異常系 (stderr: '[IO ERROR] Target is a directory', exit: 2) 成功"

# テスト6: 権限0000ファイルエラー (Pattern 5)
touch no_perm.txt
chmod 0000 no_perm.txt

# root(EUID=0)で実行されている場合はパーミッションエラーをスキップする等の考慮も必要だが、sandboxはjulesユーザ
./floor_runner no_perm.txt 1> stdout.log 2> stderr.log
RET_CODE=$?

chmod 644 no_perm.txt
rm -f no_perm.txt

if [ $RET_CODE -ne 2 ]; then
    sao_fail "権限なしファイル指定時の終了コードが 2 ではない (返り値: ${RET_CODE})。"
fi

if [ -s stdout.log ]; then
    sao_fail "権限なしファイル指定時に stdout へ不要な出力がされている。"
fi

STDERR_OUT=$(cat stderr.log)
if [[ "$STDERR_OUT" != *"[IO ERROR]"* ]]; then
    echo "--- 実際の stderr ---"
    echo "$STDERR_OUT"
    sao_fail "権限なしファイル指定時の stderr メッセージに '[IO ERROR]' が含まれていない。"
fi
sao_pass "Pattern 5: 権限なしファイル異常系 (stderr: '[IO ERROR] ...', exit: 2) 成功"

sao_complete "Floor_09_IronWall"
