#!/bin/zsh
source "$HOME/.config/wofi/source-me.sh"
check_commands() {
    for cmd in iwctl awk grep; do
        if ! command -v $cmd &> /dev/null; then
            notify-send "Error: $cmd is not installed." >&2
            exit 1
        fi
    done
}

check_commands

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
    iwctl station wlan0 disconnect
    msg
    ;;
"Scan Networks")
    iwctl station wlan0 scan
    network=$(iwctl station wlan0 get-networks | awk 'NR>4 && $1 ~ /^[\x20-\x7E]+$/ {print $1}' | wofii -d)
    if [[ -n "$network" ]]; then
        if iwctl known-networks list | grep -Fxq "$network"; then
            iwctl station wlan0 connect "$network"
            msg
        else
            echo "Enter password for $network (leave empty if open network):"
            WIFIPASS=$(echo "if connection is stored, hit enter" | wofii -P -d --prompt "password" --lines 1)
            if [[ -n "$WIFIPASS" ]]; then
                iwctl station wlan0 connect "$network" --passphrase "$WIFIPASS"
                msg
            else
                iwctl station wlan0 connect "$network"
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
        iwctl station wlan0 connect "$SSID" --passphrase "$WIFIPASS"
        msg
    else
        iwctl station wlan0 connect "$SSID"
        msg
    fi
    ;;
esac
