#!/usr/bin/env bash

# Define available power modes
MODES=("power-saver" "balanced" "performance")

# Show options in rofi
CHOICE=$(printf "%s\n" "${MODES[@]}" | rofi -dmenu -p "Select Power Mode")

# Apply selected mode
if [[ " ${MODES[*]} " =~ " ${CHOICE} " ]]; then
    powerprofilesctl set "$CHOICE"
    notify-send "Power Profile" "Switched to $CHOICE mode"
else
    notify-send "Power Profile" "No valid selection made"
fi
