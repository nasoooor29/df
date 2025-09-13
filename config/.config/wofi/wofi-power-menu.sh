#!/usr/bin/env bash
source "$HOME/.config/wofi/source-me.sh"
# Kill any running wofi instances
pkill -x wofi && return

actions=$(echo -e "   Lock\n   Shutdown\n   Reboot\n $(printf '\u200A')  Suspend\n   Hibernate\n   Logout")

# Display logout menu
selected_option=$(echo -e "$actions" | wofii -d)

# Perform actions based on the selected option
case "$selected_option" in
*Lock)
  gdmflexiserver
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
