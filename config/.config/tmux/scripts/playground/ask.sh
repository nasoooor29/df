#!/bin/bash

# Check if at least one argument is passed (prompt)
if [[ $# -lt 1 ]]; then
    echo "Usage: ask.sh <prompt>"
    exit 1
fi

# Extract the prompt from the first argument
prompt="$1"

# Use fzf-tmux with popup style if inside tmux
if [[ -n "$TMUX" ]]; then
    temp_file=$(mktemp)
    # Open a tmux popup to ask for input
    tmux display-popup -d '#{pane_current_path}' -w 40% -h 9% -E "bash -c 'read -p \"$prompt: \" question; echo \$question > $temp_file'"
    # Read the answer from the temporary file
    answer=$(cat "$temp_file")
    # Clean up the temporary file
    rm "$temp_file"
else
    # If not in tmux, use standard read
    read -p "$prompt: " answer
fi

# Output the selected choice
if [[ -n "$answer" ]]; then
    echo "$answer"
    exit 0
else
    exit 1
fi
