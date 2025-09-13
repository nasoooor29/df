#!/bin/zsh

if pgrep -x "kanata" >/dev/null; then
    pkill -x "kanata"
else
    kanata &
fi
