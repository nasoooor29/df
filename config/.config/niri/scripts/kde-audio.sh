#!/usr/bin/env bash
set -euo pipefail

DEVICE_NAME="DESKTOP-CUJ8CAU"

DEVICE=$(
    kdeconnect-cli --list-available --id-name-only | grep DESKTOP-CUJ8CAU | awk '{print $1}'
)

if [[ -z "$DEVICE" ]]; then
    echo "Device '$DEVICE_NAME' not found."
    exit 1
fi

OBJECT="/modules/kdeconnect/devices/$DEVICE/remotesystemvolume"
INTERFACE="org.kde.kdeconnect.device.remotesystemvolume"

usage() {
    cat <<EOF
Usage:
  $0 list
  $0 volume "<sink name>" <0-100>
  $0 mute "<sink name>"
  $0 unmute "<sink name>"

Examples:
  $0 list
  $0 volume "Voicemeeter Input (VB-Audio Voicemeeter VAIO)" 50
  $0 mute "Voicemeeter Input (VB-Audio Voicemeeter VAIO)"
  $0 unmute "Voicemeeter Input (VB-Audio Voicemeeter VAIO)"
EOF
}

list_sinks() {
    busctl --user get-property \
        org.kde.kdeconnect \
        "$OBJECT" \
        "$INTERFACE" \
        sinks |
        python3 -c '
import sys, json
parts = sys.stdin.read().split()
sinks = json.loads(bytes(map(int, parts[2:])))
for s in sinks:
    print("{} {} ({}%)".format("*" if s["enabled"] else " ", s["name"], s["volume"]))
'
}

set_volume() {
    busctl --user call \
        org.kde.kdeconnect \
        "$OBJECT" \
        "$INTERFACE" \
        sendVolume \
        si \
        "$1" \
        "$2"
}

set_mute() {
    busctl --user call \
        org.kde.kdeconnect \
        "$OBJECT" \
        "$INTERFACE" \
        sendMuted \
        sb \
        "$1" \
        "$2"
}
get_volume() {
    busctl --user get-property \
        org.kde.kdeconnect \
        "$OBJECT" \
        "$INTERFACE" \
        sinks |
        python3 -c '
import sys, json
parts = sys.stdin.read().split()
sinks = json.loads(bytes(map(int, parts[2:])))
sink_name = sys.argv[1]
for s in sinks:
    if s["name"] == sink_name:
        print(s["volume"])
' "$1"
}
change_by() {
    local sink_name="$1"
    local amount="$2"
    local current_volume
    local new_volume

    current_volume=$(get_volume "$sink_name")

    if [[ -z "$current_volume" ]]; then
        echo "Sink not found: $sink_name" >&2
        return 1
    fi

    new_volume=$((current_volume + amount))

    ((new_volume > 100)) && new_volume=100
    ((new_volume < 0)) && new_volume=0

    set_volume "$sink_name" "$new_volume"

    sleep 0.3

    echo "Requested volume: $new_volume"
    echo "Reported volume: $(get_volume "$sink_name")"
}

case "${1:-}" in
list)
    list_sinks
    ;;
volume)
    # if both $2 and $3 are provided, set the volume else show the volume of the sink
    if [[ -n "${2:-}" && -n "${3:-}" ]]; then
        set_volume "$2" "$3"
    else
        # show the volume of the sink
        get_volume "$2"
    fi
    ;;
mute)
    set_mute "$2" true
    ;;
unmute)
    set_mute "$2" false
    ;;
change_by)
    # adjust the volume of the sink by a certain amount
    change_by "$2" "$3"
    ;;
*)
    usage
    exit 1
    ;;
esac
