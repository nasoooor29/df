# Check if at least one argument is passed (prompt)
if [[ $# -lt 1 ]]; then
    echo "Usage: display.sh <prompt>"
    exit 1
fi

message=$1

if [ -n "$TMUX" ]; then
    tmux display-popup -d '#{pane_current_path}' -w 40% -h 9% -E "echo '$message'; read"
else
    echo "$message"
fi
