#!/bin/bash

echo "Installing optional CLI tools..."
sudo pacman -S $UNATTEND_INSTALL_PACMAN $INSTALL_NEEDED ansible-core openssh bat btop net-tools bind docker