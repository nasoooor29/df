#!/bin/bash

sudo pacman -S $UNATTEND_INSTALL_PACMAN $INSTALL_NEEDED zsh

chsh -s $(which zsh)