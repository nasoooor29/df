#!/bin/bash

# Install Python
sudo pacman -S $UNATTEND_INSTALL_PACMAN $INSTALL_NEEDED python python-pip

# Install uv (fast Python package installer)
curl -LsSf https://astral.sh/uv/install.sh | sh