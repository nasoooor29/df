#!/bin/bash

sudo pacman -S $UNATTEND_INSTALL_PACMAN $INSTALL_NEEDED git base-devel
if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
fi
