#!/usr/bin/env bash

# Kill any running wofi instances
pkill -x wofi && return

actions=$(echo -e "   Lock\n   Shutdown\n   Reboot\n $(printf '\u200A')  Suspend\n   Hibernate\n   Logout")

# Display logout menu
# wofi -d --style ~/.config/wofi/themes/mocha.css --conf ~/.config/wofi/config-no-bar -W 30 -l 3 -x -190 -H 300
selected_option=$(echo -e "$actions" | wofi -d --style ~/.config/wofi/themes/mocha.css --conf ~/.config/wofi/config-no-bar -W 30 -l 3 -x -190 -H 300)

# Perform actions based on the selected option
case "$selected_option" in
*Lock)
  hyprlock
  ;;
*Shutdown)
  systemctl poweroff
  ;;
*Reboot)
  systemctl reboot
  ;;
*Suspend)
  systemctl suspend
  ;;
*Hibernate)
  systemctl hibernate
  ;;
*Logout)
  hyprctl dispatch exit 0
  ;;
esac
