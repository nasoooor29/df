#!/bin/bash

files=$(fd . '/home/nasoooor')

source "$HOME/.config/wofi/source-me.sh"
rofi_command="wofi -dmenu -i -p 'search files' --conf $CONFIG --style $STYLE"
rofi_input=$(printf "%s\n" "${files[@]}")
file=$(echo -e "$rofi_input" | $rofi_command)

if [ $? -eq 0 ]; then
  xdg-open "$file"
fi
