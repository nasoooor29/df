#!/bin/zsh
source "$HOME/.config/wofi/source-me.sh"
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
    echo "Action failed" | wofii -d --prompt "Error"
}

action_success() {
    echo "Action succeeded" | wofii -d --prompt "Success" --lines 1
}

msg() {
    if [[ $? -eq 0 ]]; then
        action_success
    else
        action_failed
    fi
}

source "$HOME/.config/wofi/source-me.sh"
action=$(echo -e "Disconnect\nScan Networks\nConnect Manual" | wofii -d --prompt "Choose an action")
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
    network=$(nmcli -f SSID dev wifi | wofii -d)
    if [[ -n "$network" ]]; then
        if nmcli con show | grep -q "$network"; then
            nmcli dev wifi connect "$network" ifname wlan0
            msg
        else
            echo "Enter password for $network (leave empty if open network):"
            WIFIPASS=$(echo "if connection is stored, hit enter" | wofii -P -d --prompt "password" --lines 1)
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
    SSID=$(wofii -d --prompt "SSID" --lines 1)
    echo "Enter password for $SSID (leave empty if open network):"
    WIFIPASS=$(wofii -P -d --prompt "password" --lines 1)
    if [[ -n "$WIFIPASS" ]]; then
        nmcli dev wifi connect "$SSID" password "$WIFIPASS" ifname wlan0
        msg
    else
        nmcli dev wifi connect "$SSID" ifname wlan0
        msg
    fi
    ;;
esac
