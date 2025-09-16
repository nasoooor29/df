#!/usr/bin/env bash

# if you want more thing from rofi just create a script rofi-[your thing name].sh
# then thats it write your logic
if [[ $(pidof rofi) ]]; then
    pkill rofi
fi

files=($(ls $HOME/.config/rofi/rofi-*.sh))
declare -A actions
for file in "${files[@]}"; do
    filename=$(basename "$file" .sh)
    key=$(echo "${filename#rofi-}" | tr '[:upper:]' '[:lower:]')
    actions["$key"]="$file"
done

choosen=$(printf "%s\n" "${!actions[@]}" | sort | rofi -dmenu -p "Select an option")

if [[ ! -n "${actions[$choosen]}" ]]; then
    exit 0
fi

chmod +x "${actions[$choosen]}"

# Execute the selected script
"${actions[$choosen]}"