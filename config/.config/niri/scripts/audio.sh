#!/usr/bin/env bash
set -euo pipefail

source "$HOME/.config/niri/scripts/dock.sh"

KDE_AUDIO="$HOME/.config/niri/scripts/kde-audio.sh"
command="${1:-}"

if [[ -z "$command" ]]; then
    echo "Usage: $0 {raise|lower|mute|mic-mute}" >&2
    exit 1
fi

if is_docked; then
    echo "On dock, using KDE Connect for audio control" >&2
    case "$command" in
    raise)
        bash "$KDE_AUDIO" change_by "Speakers (2- USB Audio CODEC )" +2
        ;;
    lower)
        bash "$KDE_AUDIO" change_by "Speakers (2- USB Audio CODEC )" -2
        ;;
    mute)
        bash "$KDE_AUDIO" mute
        ;;
    mic-mute)
        bash "$KDE_AUDIO" mic-mute
        ;;
    *)
        echo "Unknown command: $command" >&2
        exit 1
        ;;
    esac
else
    echo "Not on dock, using wpctl for audio control" >&2
    case "$command" in
    raise)
        exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.0
        ;;
    lower)
        exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
        ;;
    mute)
        exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    mic-mute)
        exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        ;;
    *)
        echo "Unknown command: $command" >&2
        exit 1
        ;;
    esac
fi
