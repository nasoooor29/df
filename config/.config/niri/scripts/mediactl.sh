#!/usr/bin/env bash
set -u

command="${1:-}"
shift || true
source "$HOME/.config/niri/scripts/dock.sh"

if ! is_docked; then
    echo "Not on dock, using default player" >&2
    exec playerctl "$command" "$@"
fi

if [[ -z "$command" ]]; then
    echo "Usage: mediactl <play-pause|play|pause|stop|next|previous>" >&2
    exit 2
fi

find_spotify_player() {
    local player service identity

    while IFS= read -r player; do
        [[ -n "$player" ]] || continue

        service="org.mpris.MediaPlayer2.$player"

        identity="$(
            gdbus call \
                --session \
                --dest "$service" \
                --object-path /org/mpris/MediaPlayer2 \
                --method org.freedesktop.DBus.Properties.Get \
                org.mpris.MediaPlayer2 Identity 2>/dev/null || true
        )"

        if [[ "${identity,,}" == *spotify* ]]; then
            printf '%s\n' "$player"
            return 0
        fi
    done < <(playerctl -l 2>/dev/null)

    return 1
}

player="$(find_spotify_player || true)"
args=()

if [[ -n "$player" ]]; then
    args=(-p "$player")
fi

if [[ "$command" == "play-pause" ]]; then
    status="$(playerctl "${args[@]}" status 2>/dev/null || true)"

    case "$status" in
    Playing)
        exec playerctl "${args[@]}" pause
        ;;
    Paused | Stopped)
        exec playerctl "${args[@]}" play
        ;;
    *)
        exec playerctl play-pause
        ;;
    esac
fi

if [[ -n "$player" ]]; then
    if playerctl "${args[@]}" "$command" "$@"; then
        exit 0
    fi
fi

exec playerctl "$command" "$@"
