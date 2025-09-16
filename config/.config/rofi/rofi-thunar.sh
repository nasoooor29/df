#!/usr/bin/env bash

dir_to_open=$(find $HOME -maxdepth 3 -type d -not -path "*/.*" -o -path "$HOME/df/*" -type d -not -path "*/.git*" | rofi -dmenu -p "Search directory:")

if [ -n "$dir_to_open" ]; then
    thunar "$dir_to_open"
fi