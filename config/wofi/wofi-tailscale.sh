#!/bin/bash

source "$HOME/.config/wofi/source-me.sh"
# current status

current_status=$(tailscale status --json | jq -r '.BackendState')
res=$(echo -e "Current Tailscale status: $current_status\nstart\nstop" | wofi --conf "$CONFIG" --style "$STYLE" --dmenu --prompt "Tailscale Status")
if [[ $? -ne 0 ]]; then
    exit 1
fi
if [[ "$res" == "start" ]]; then
    if [[ "$current_status" == "Running" ]]; then
        notify-send "Tailscale is already running."
    else
        sudo tailscale up
        notify-send "Tailscale started."
    fi
elif [[ "$res" == "stop" ]]; then
    if [[ "$current_status" == "Running" ]]; then
        sudo tailscale down && notify-send "Tailscale stopped." || notify-send "Failed to stop Tailscale."
    else
        notify-send "Tailscale is not running."
    fi
else
    notify-send "Invalid option selected."
fi
