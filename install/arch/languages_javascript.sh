#!/bin/bash

# Install Node.js, npm, and JavaScript tools
sudo pacman -S $UNATTEND_INSTALL_PACMAN $INSTALL_NEEDED nodejs npm

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

# Install pnpm
sudo npm install -g pnpm

# Install bun
curl -fsSL https://bun.sh/install | bash
