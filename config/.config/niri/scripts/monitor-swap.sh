while true; do
    if ! lsusb | grep -q 046d:c08b; then
        niri msg output "eDP-1" on
        niri msg output "DP-2" off
        echo "Monitor disconnected"
    else
        niri msg output "eDP-1" off
        niri msg output "DP-2" on
        echo "Monitor connected"
    fi
    sleep 0.5
done
