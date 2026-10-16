#!/usr/bin/env bash
set -e

echo "[1/6] Building with ASan..."
make clean
make asan

echo "[2/6] Testing help and version..."
./gear -h
./gear --help
./gear -v
./gear --version

echo "[3/6] Testing stat..."
./gear stat

echo "[4/6] Testing memo..."
export GEAR_MEMO_PATH="./test_memo.log"
rm -f "$GEAR_MEMO_PATH"
./gear memo "Link Start"
if [ ! -f "$GEAR_MEMO_PATH" ]; then
    echo "Error: Memo file was not created!"
    exit 1
fi
grep -q "Link Start" "$GEAR_MEMO_PATH"
rm -f "$GEAR_MEMO_PATH"

echo "[5/6] Testing clean (dry-run and execute)..."
TEST_DIR="./test_sandbox"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
touch "$TEST_DIR/hero.png"
touch "$TEST_DIR/notes.txt"
touch "$TEST_DIR/main.c"
touch "$TEST_DIR/data.zip"
touch "$TEST_DIR/other.unknown"

# Test dry-run
./gear clean "$TEST_DIR" --dry-run
if [ ! -f "$TEST_DIR/hero.png" ]; then
    echo "Error: Dry-run moved file!"
    exit 1
fi

# Test actual clean
./gear clean "$TEST_DIR"
if [ ! -f "$TEST_DIR/Images/hero.png" ] || \
   [ ! -f "$TEST_DIR/Docs/notes.txt" ] || \
   [ ! -f "$TEST_DIR/Code/main.c" ] || \
   [ ! -f "$TEST_DIR/Archives/data.zip" ] || \
   [ ! -f "$TEST_DIR/Others/other.unknown" ]; then
    echo "Error: Files were not organized correctly!"
    exit 1
fi
rm -rf "$TEST_DIR"

echo "[6/6] Testing error cases..."
NON_EXISTENT="./non_existent_folder_12345"
rm -rf "$NON_EXISTENT"

set +e
ERR_OUTPUT=$(./gear clean "$NON_EXISTENT" 2>&1)
EXIT_CODE=$?
set -e

if [ $EXIT_CODE -eq 0 ]; then
    echo "Error: Expected non-zero exit status on non-existent directory!"
    exit 1
fi

if [ -z "$ERR_OUTPUT" ]; then
    echo "Error: Expected stderr output on non-existent directory!"
    exit 1
fi

echo "Cleaning up build artifacts..."
make clean

echo "ALL TESTS PASSED SUCCESSFULLY!"
