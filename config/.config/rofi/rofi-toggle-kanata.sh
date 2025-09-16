#!/usr/bin/env bash

if pgrep -x "kanata" >/dev/null; then
    pkill -x "kanata"
else
    kanata &
fi
