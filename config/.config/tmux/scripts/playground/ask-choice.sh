#!/bin/bash

# Check if at least two arguments are passed (prompt and options)
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <prompt> <option1> [option2] [option3] ..."
    exit 1
fi

# Extract the prompt from the first argument
prompt="$1"

# Shift the first argument (prompt) and treat the rest as options
shift
options="$@"

# Use fzf-tmux with popup style if inside tmux
if [[ -n "$TMUX" ]]; then
    choice=$(echo -e "$options" | tr ' ' '\n' | fzf-tmux -p 40%,50% --border --margin=0 --prompt="$prompt ")
else
    choice=$(echo -e "$options" | tr ' ' '\n' | fzf --prompt="$prompt ")
fi
# Output the selected choice
if [[ -n "$choice" ]]; then
    echo $choice
fi
