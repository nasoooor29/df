#!/bin/zsh

check_commands() {
    for cmd in nmcli awk grep; do
        if ! command -v $cmd &>/dev/null; then
            notify-send "Error: $cmd is not installed." >&2
            exit 1
        fi
    done
}

check_commands

action_failed() {
    echo "Action failed" | rofi -dmenu -p "Error"
}

action_success() {
    echo "Action succeeded" | rofi -dmenu -p "Success" -l 1
}

msg() {
    if [[ $? -eq 0 ]]; then
        action_success
    else
        action_failed
    fi
}

action=$(echo -e "Disconnect\nScan Networks\nConnect Manual" | rofi -dmenu -p "Choose an action")
if [[ $? -eq 1 ]]; then
    notify-send "Error: Failed to choose an action."
fi

case "$action" in
"Disconnect")
    nmcli dev disconnect wlan0
    msg
    ;; 
"Scan Networks")
    nmcli dev wifi rescan wlan0
    network=$(nmcli -f SSID dev wifi | rofi -dmenu)
    if [[ -n "$network" ]]; then
        if nmcli con show | grep -q "$network"; then
            nmcli dev wifi connect "$network" ifname wlan0
            msg
        else
            echo "Enter password for $network (leave empty if open network):"
            WIFIPASS=$(echo "if connection is stored, hit enter" | rofi -dmenu -password -p "password" -l 1)
            if [[ -n "$WIFIPASS" ]]; then
                nmcli dev wifi connect "$network" password "$WIFIPASS" ifname wlan0
                msg
            else
                nmcli dev wifi connect "$network" ifname wlan0
                msg
            fi
        fi
    fi
    ;; 

"Connect Manual")
    echo "Enter SSID:"
    SSID=$(rofi -dmenu -p "SSID" -l 1)
    echo "Enter password for $SSID (leave empty if open network):"
    WIFIPASS=$(rofi -dmenu -password -p "password" -l 1)
    if [[ -n "$WIFIPASS" ]]; then
        nmcli dev wifi connect "$SSID" password "$WIFIPASS" ifname wlan0
        msg
    else
        nmcli dev wifi connect "$SSID" ifname wlan0
        msg
    fi
    ;; 
esac
