#!/bin/bash

# Check for required arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <user> <host> <remote_path>"
    exit 1
fi

REMOTE_USER="$1"
REMOTE_HOST="$2"
REMOTE_PATH="$3"
LOCAL_MOUNT="$HOME/remote_nvim"

# Ensure SSHFS is installed
if ! command -v sshfs &>/dev/null; then
    echo "Error: sshfs is not installed. Install it first."
    exit 1
fi

# Create mount point if it doesn't exist
mkdir -p "$LOCAL_MOUNT"

# Mount remote directory
echo "Mounting $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH to $LOCAL_MOUNT..."
sshfs "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH" "$LOCAL_MOUNT"

cd $LOCAL_MOUNT
# Open Neovim in the mounted directory
nvim "$LOCAL_MOUNT"

# Unmount after exiting Neovim
echo "Unmounting $LOCAL_MOUNT..."
fusermount -u "$LOCAL_MOUNT"

echo "Done."
