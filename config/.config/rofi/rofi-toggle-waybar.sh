#!/usr/bin/env bash

if pgrep -x "waybar" >/dev/null; then
    pkill -x "waybar"
else
    waybar &
fi
