#!/bin/bash

source "$HOME/.config/wofi/source-me.sh"
icons=$(find ~/.config/wofi/svgs/feather/icons)

ICONS=$(echo "$icons" | tr ' ' '\n')
cliphist-wofi-img $ICONS | wofi --dmenu --allow-images --pre-display-cmd "cliphist-wofi-img %s" | cliphist-wofi-img decode | wl-copy
