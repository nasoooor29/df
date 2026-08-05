STATE_LOCATION="$HOME/.config/niri/scripts/state"

if [ "$(cat $STATE_LOCATION)" = "ON" ]; then
    niri msg output "eDP-1" off
    niri msg output "DP-2" on
    notify-send -t 1 "Monitor connected"
    echo "OFF" >$STATE_LOCATION
else
    niri msg output "eDP-1" on
    niri msg output "DP-2" off
    notify-send -t 1 "Monitor disconnected"
    echo "ON" >$STATE_LOCATION
fi

flip_state
