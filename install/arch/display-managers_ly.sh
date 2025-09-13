#!/bin/bash

sudo pacman -S $UNATTEND_INSTALL_PACMAN $INSTALL_NEEDED ly
sudo systemctl enable ly
sudo systemctl start ly

