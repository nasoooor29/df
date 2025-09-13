# if you want more thing from wofi just create a script wofi-[your thing name].sh
# then thats it write your logic
source "$HOME/.config/wofi/source-me.sh"
if [[ $(pidof wofi) ]]; then
    pkill wofi
fi

files=($(ls $HOME/.config/wofi/wofi-*.sh))
declare -A actions
for file in "${files[@]}"; do
    filename=$(basename "$file" .sh)
    key=$(echo "${filename#wofi-}" | tr '[:upper:]' '[:lower:]')
    actions["$key"]="$file"
done

choosen=$(printf "%s\n" "${!actions[@]}" | wofii -d)

echo "$choosen"

if [[ ! -n "${actions[$choosen]}" ]]; then
    # notify-send "file does not exist"
    return
fi
chmod +x "${actions[$choosen]}"
# Execute the selected script
"${actions[$choosen]}"

# if ! STYLE=1 output=$("${actions[$choosen]}" 2>&1); then
#     # notify-send "An error happened" "$output"
# fi
