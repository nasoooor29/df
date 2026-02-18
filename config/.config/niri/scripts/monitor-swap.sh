#!/bin/bash

CONFIG_FILE="$HOME/.config/niri/dms/outputs.kdl"   # <-- CHANGE THIS

while true; do
  if ! lsusb | grep -q "046d:c08b"; then
    echo "Monitor disconnected"

    # Remove 'off' inside eDP-1 block only
    awk '
    BEGIN { in_block=0 }
    /output "eDP-1"/ { in_block=1 }
    in_block && /^\}/ { in_block=0 }
    !(in_block && /^[[:space:]]*off$/)
    ' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

  else
    echo "Monitor connected"

    # Add 'off' inside eDP-1 block if not already present
    awk '
    BEGIN { in_block=0; has_off=0 }
    /output "eDP-1"/ { in_block=1; has_off=0 }
    in_block && /^[[:space:]]*off$/ { has_off=1 }
    in_block && /^\}/ {
        if (!has_off) print "    off"
        in_block=0
    }
    { print }
    ' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

  fi

  sleep 0.5
done
