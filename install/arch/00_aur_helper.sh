#!/bin/bash

# Install AUR helper (yay)
trap 'echo "Error installing AUR helper. Please check the script."; exit 1' ERR

echo "Installing AUR helper (yay)..."
sudo pacman -S $UNATTEND_INSTALL_PACMAN $INSTALL_NEEDED git base-devel
if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
fi

