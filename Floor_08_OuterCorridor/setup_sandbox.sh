#!/bin/bash
set -e

# カレントディレクトリをスクリプトの存在するディレクトリに変更
cd "$(dirname "$0")"

TARGET_DIR="./dungeon_box"

# 実験用フォルダを再作成
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

# ダミーファイルの生成
# map.png, avatar.jpg, quest.pdf, readme.txt, kernel.c, backup.zip, mystery.dat, .hidden_key
touch "$TARGET_DIR/map.png"
touch "$TARGET_DIR/avatar.jpg"
touch "$TARGET_DIR/quest.pdf"
touch "$TARGET_DIR/readme.txt"
touch "$TARGET_DIR/kernel.c"
touch "$TARGET_DIR/backup.zip"
touch "$TARGET_DIR/mystery.dat"
touch "$TARGET_DIR/.hidden_key"

echo "Sandbox environment created at $TARGET_DIR"
