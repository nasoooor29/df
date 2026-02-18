BASE_DIR="$HOME/repos/playground"
branches=$(ls "$BASE_DIR" | sed 's/^/[PLAYGROUND] /')

COMMAND=$(echo -e "[PLAYGROUND] new\n[PLAYGROUND] clear\n$branches")

get_sessions() {
    tmux ls -F "#S"
}
get_zoxide() {
    zoxide query --list
    find ~/repos -maxdepth 1
}

CHOOSEN=$(
    tmux ls -F "#S" | tac | fzf-tmux -p 60%,40% --border --margin=0 \
        --header '  A-1 tmux  A-2 zoxide  A-3 playgrounds  A-4 sesh-things  A-d kill ' \
        --no-sort --ansi --border-label ' GOOD BOY ' --prompt '  ' --border=rounded \
        --bind "tab:down,btab:up" \
        --bind "alt-1:change-prompt(  )+reload(tmux ls -F \"#S\" | tac)" \
        --bind "alt-2:change-prompt(  )+reload(zoxide query --list; find ~/repos -maxdepth 1)" \
        --bind "alt-3:change-prompt(  )+reload(echo -e \"$COMMAND\")" \
        --bind "alt-4:change-prompt(  )+reload(echo -e \"$COMMAND\")" \
        --bind "alt-d:execute(tmux kill-session -t {})+change-prompt(  )+reload(tmux ls -F \"#S\" | tac)" \
        --bind "alt-k:up,alt-j:down" \
        --bind alt-\':abort
)

if [ -z "$CHOOSEN" ]; then
    exit 0
fi

# playground handling
if [[ "$CHOOSEN" == "[PLAYGROUND]"* ]]; then
    CHOOSEN_NO_PREFIX="${CHOOSEN#\[PLAYGROUND\] }"
    "$HOME/dotfiles/.config/tmux/scripts/playground/playground.sh" "$CHOOSEN_NO_PREFIX"
    exit 0
fi

# Cache sessions list (you used it but never set it)
sessions="$(tmux ls -F "#S" 2>/dev/null || true)"

# If they picked an existing tmux session name, just switch to it
if echo "$sessions" | grep -Fxq "$CHOOSEN"; then
    tmux switch-client -t "$CHOOSEN"
    exit 0
fi

# Otherwise treat selection as a directory if it exists
if [ ! -d "$CHOOSEN" ]; then
    # If it's not a directory, do nothing (or handle it as needed)
    exit 0
fi

SESSION_NAME="$(basename "$CHOOSEN" | tr '.' '_')"

# Create session starting in the directory
tmux new-session -d -s "$SESSION_NAME" -c "$CHOOSEN"

# Example “layout” logic based on the chosen dir (NOT pwd)
if [[ "$CHOOSEN" == "$HOME/repos"* || "$CHOOSEN" == "$HOME/penny"* ]]; then
    tmux new-window -t "$SESSION_NAME:2" -c "$CHOOSEN"
    tmux new-window -t "$SESSION_NAME:3" -c "$CHOOSEN"
    tmux send-keys -t "$SESSION_NAME:3" 'lazygit' C-m
    tmux send-keys -t "$SESSION_NAME:1" 'nvim' C-m
elif [[ "$CHOOSEN" == "$HOME/.config"* || "$CHOOSEN" == "$HOME/df"* ]]; then
    tmux new-window -t "$SESSION_NAME:2" -c "$CHOOSEN"
    tmux send-keys -t "$SESSION_NAME:1" 'nvim' C-m
fi

tmux switch-client -t "$SESSION_NAME:1"
# Fallback: if it's neither an existing session nor a directory, do nothing (or handle it)
exit 0
