#!/bin/bash

select_packages() {
    local platform="$1"
    local dir="./install/$platform"

    echo "📋 Select packages to install:"
    mapfile -t ALL_SCRIPTS < <(cd "$dir" && ls *.sh)

    SELECTED=()
    for script in "${ALL_SCRIPTS[@]}"; do
        read -p "Install $script? [y/N]: " ans
        [[ "$ans" =~ ^[Yy]$ ]] && SELECTED+=("$script")
    done
}
