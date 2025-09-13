while true; do
  if ! lsusb | grep -q 046d:c08b; then
    hyprctl keyword monitor "DP-2, disable"
    echo "Monitor disconnected"
  else
    hyprctl keyword monitor "DP-2,1920x1080@100,1280x0,1.0,mirror,eDP-1"
    echo "Monitor connected"
  fi
  sleep 0.5
done
