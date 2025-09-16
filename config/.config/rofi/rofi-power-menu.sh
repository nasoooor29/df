#!/usr/bin/env bash

# Kill any running rofi instances
pkill -x rofi && return

actions=$(echo -e "   Lock\n   Shutdown\n   Reboot\n $(printf '/\u200A')   Suspend\n   Hibernate\n   Logout")

# Display logout menu
selected_option=$(echo -e "$actions" | rofi -dmenu -p "Power Menu")

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
