#!/bin/bash

sudo pacman -S $UNATTEND_INSTALL_PACMAN $INSTALL_NEEDED bluez-utils
sudo yay -S $UNATTEND_INSTALL_YAY $INSTALL_NEEDED bluetui

