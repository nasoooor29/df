#!/bin/bash

files=$(fd . '/home/nasoooor')

rofi_command="rofi -dmenu -i -p 'search files'"
rofi_input=$(printf "%s\n" "${files[@]}")
file=$(echo -e "$rofi_input" | $rofi_command)

if [ $? -eq 0 ]; then
  xdg-open "$file"
fi
