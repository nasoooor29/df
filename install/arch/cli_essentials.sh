#!/bin/bash

echo "Installing essential CLI tools..."
sudo pacman -S $UNATTEND_INSTALL_PACMAN $INSTALL_NEEDED man-db unzip zip zsh stow wget git eza jq sshfs zoxide ripgrep