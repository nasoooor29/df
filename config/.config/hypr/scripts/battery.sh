#!/bin/bash

SOUND_EFFECT="$HOME/dotfiles/.config/hypr/soundEffects/mixkit-software-interface-start-2574.wav"
BATTERY_CAPACITY_PATH="/sys/class/power_supply/BAT0/capacity"
BATTERY_STATUS_PATH="/sys/class/power_supply/BAT0/status"
# AUDIO_SINK="@DEFAULT_AUDIO_SINK@"
MODES=("power-saver" "balanced" "performance")
LOW_BATTERY_THRESHOLD=20
SLEEP_DURATION_LOW=180
SLEEP_DURATION_NORMAL=10
# VOLUME_THRESHOLD=0.65
while true; do
    bat_status=$(cat "$BATTERY_STATUS_PATH")
    if [ "$bat_status" = "Charging" ]; then
        # Set to performance mode when charging
        powerprofilesctl set "performance"
        sleep "$SLEEP_DURATION_NORMAL"
        continue
    fi

    bat_lvl=$(cat "$BATTERY_CAPACITY_PATH")
    if [ "$bat_lvl" -le "$LOW_BATTERY_THRESHOLD" ]; then
        # Set to power-saver mode when battery is low
        powerprofilesctl set "power-saver"
        notify-send -t 2000 --urgency=CRITICAL "Battery Low" "Level: ${bat_lvl}%"
        paplay "$SOUND_EFFECT"
        sleep "$SLEEP_DURATION_LOW"
    else
        # Set to balanced mode otherwise
        powerprofilesctl set "balanced"
        sleep "$SLEEP_DURATION_NORMAL"
    fi
done
