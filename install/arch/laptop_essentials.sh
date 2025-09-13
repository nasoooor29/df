#!/bin/bash

echo "Installing laptop-specific apps..."
sudo pacman -S $UNATTEND_INSTALL_PACMAN $INSTALL_NEEDED brightnessctl bluez-utils impala iwd