#!/usr/bin/env bash

# Kill any running rofi instances
pkill -x rofi && exit

# Define actions
actions="  Lock
  Shutdown
  Reboot
  Suspend
  Hibernate
  Logout"

# Show menu with rofi
selected_option=$(echo -e "$actions" | rofi -dmenu -i -p "" \
  -theme-str '
    window {
      anchor: north east;
      location: northeast;
      width: 20%;
      y-offset: 10px;
      x-offset: -10px;
    }
    entry {
      enabled: false;
    }
    listview {
      scrollbar: false;
      fixed-height: false;
    }
    prompt {
      enabled: false;
    }
  ')
# Perform action
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
