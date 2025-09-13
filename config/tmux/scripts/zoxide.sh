SELECTION=$(zoxide query --list | fzf-tmux -p 60%,40% --border --margin=0 \
    --header "" \
    --no-sort --ansi --border-label ' My Repos ' --prompt '  ' --border=rounded \
    --bind "tab:down,btab:up" \
    --bind "alt-k:up,alt-j:down" \
    --bind alt-\o:abort)

if [[ -z $SELECTION ]]; then
    exit 0
fi

# Create or attach to a tmux session named after the repository
SESSION_NAME="$SELECTION"
CURRENT_SESSION=$(tmux display-message -p '#S')

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux new-session -d -s "$SESSION_NAME" -c "$SELECTION" -n "nvim"
    tmux new-window -t "$SESSION_NAME:2" -n "Terminal" -c "$SELECTION"
    tmux new-window -t "$SESSION_NAME:3" -n "LazyGit" -c "$SELECTION"
    tmux send-keys -t "$SESSION_NAME:1" "nvim" Enter
    tmux send-keys -t "$SESSION_NAME:3" "lazygit" Enter
fi

if [ "$CURRENT_SESSION" != "$SESSION_NAME" ]; then
    tmux switch-client -t "$SESSION_NAME"
    tmux select-window -t 1
    exit 0
fi

tmux attach-client -t $SESSION_NAME
tmux select-window -t 1
