#!/bin/bash

# Install Rust via rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Source cargo environment
source $HOME/.cargo/env

# Install clippy (linter)
rustup component add clippy