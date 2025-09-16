#!/usr/bin/env bash

project_name=$(sesh list | rofi -dmenu -p "Connect to project:")

if [ -n "$project_name" ]; then
    kitty sh -c 'sesh connect "$project_name"'
fi
