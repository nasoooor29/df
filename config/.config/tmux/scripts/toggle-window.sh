# Function to check if window 2 exists
function window_exists {
    tmux list-windows | grep -q "^2:"
}

# Function to open or switch to window 2
function open_window {
    if ! window_exists; then
        tmux new-window -t 2 -n "Terminal"
    fi
    tmux select-window -t 2
}

# Function to close window 2 by switching to window 1
function close_window {
    tmux select-window -t 1
}

# Function to toggle between window 1 and 2
function toggle_window {
    current_window=$(tmux display-message -p "#I")
    if [[ "$current_window" -eq 1 ]]; then
        open_window
    else
        close_window
    fi
}

# Function to run a command in window 2 based on the current directory
function run_command {
    nvim_session=$(tmux display-message -p "#S")

    window_command=$(tmux list-windows -F "#{window_index}:#{window_active}:#{window_name}" | grep "^1:" | awk -F ':' '{print $3}')
    if [[ "$window_command" == "nvim" ]]; then
        tmux send -t "${nvim_session}:1" Escape ":wa" Enter
    fi
    open_window

    if [[ -f "run" ]]; then
        tmux send-keys -t 2 "$(cat run)" Enter
    elif [[ -f "makefile" ]]; then
        tmux send-keys -t 2 "make run" Enter
    elif [[ -f ".air.toml" ]]; then
        tmux send-keys -t 2 "air" Enter
    elif [[ -f "Cargo.toml" ]]; then
        tmux send-keys -t 2 "cargo run" Enter
    elif [[ -f "go.mod" ]]; then
        tmux send-keys -t 2 "go run ." Enter
    elif [[ -f "package.json" ]]; then
        tmux send-keys -t 2 "bun run dev" Enter
    elif [[ -f "pyproject.toml" || -f "requirements.txt" ]]; then
        tmux send-keys -t 2 "python3 main.py" Enter
    else
        tmux send-keys -t 2 "echo 'no makefile and no supported language'" Enter
    fi
}

# Main script logic
case "$1" in
open)
    open_window
    ;;
close)
    close_window
    ;;
toggle)
    toggle_window
    ;;
run)
    run_command
    ;;
*)
    echo "Usage: $0 {open|close|toggle|run}"
    exit 1
    ;;
esac
