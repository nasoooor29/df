#!/bin/bash

set -e

SYNC_METHOD=$1
SOURCE_DIR=$2
TARGET_DIR=$3

case "$SYNC_METHOD" in
  copy)
    echo "Copying files from $SOURCE_DIR to $TARGET_DIR..."
    cp -r "$SOURCE_DIR"/* "$TARGET_DIR"/
    ;;
  symlink)
    echo "Creating symlinks from $SOURCE_DIR to $TARGET_DIR..."
    ln -sfn "$SOURCE_DIR"/* "$TARGET_DIR"/
    ;;
  stow)
    echo "Using stow to manage configs..."
    stow -d "$SOURCE_DIR" -t "$TARGET_DIR"
    ;;
  bare)
    echo "Using bare git repo for syncing..."
    git --git-dir="$SOURCE_DIR/.git" --work-tree="$TARGET_DIR" checkout
    ;;
  none)
    echo "No sync method selected. Skipping..."
    ;;
  *)
    echo "Unknown sync method: $SYNC_METHOD"
    exit 1
    ;;
esac

echo "✅ Sync complete!"