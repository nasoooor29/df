if ! lsusb | grep -q 046d:c08b; then
    niri msg output "eDP-1" on
    niri msg output "DP-1" off
    echo "Monitor disconnected"
else
    niri msg output "eDP-1" off
    niri msg output "DP-1" on
    echo "Monitor connected"
fi
