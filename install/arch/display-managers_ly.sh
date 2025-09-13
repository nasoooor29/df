#!/bin/bash

sudo pacman -S --noconfirm ly
sudo systemctl enable ly
sudo systemctl start ly

