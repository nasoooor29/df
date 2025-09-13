# Define available power modes

source "$HOME/.config/wofi/source-me.sh"
MODES=("power-saver" "balanced" "performance")

# Show options in wofi
CHOICE=$(printf "%s\n" "${MODES[@]}" | wofi --dmenu --prompt "Select Power Mode")

# Apply selected mode
if [[ " ${MODES[*]} " =~ " ${CHOICE} " ]]; then
    powerprofilesctl set "$CHOICE"
    notify-send "Power Profile" "Switched to $CHOICE mode"
else
    notify-send "Power Profile" "No valid selection made"
fi
