BASE_DIR="$HOME/repos/playground"
branches=$(ls "$BASE_DIR" | sed 's/^/[PLAYGROUND] /')

HOSTS_FILE="$HOME/.config/tmux/scripts/session-mng/servers.json"
COMMAND=$(echo -e "[PLAYGROUND] new\n[PLAYGROUND] clear\n$branches")
SSH_HOSTS=$(cat $HOSTS_FILE | jq 'keys[]' -r | sed 's/^/[SSH] /')

CHOOSEN=$(
    tmux ls -F "#S" | tac | fzf-tmux -p 60%,40% --border --margin=0 \
        --header '  A-1 tmux  A-2 zoxide  A-3 playgrounds  A-4 ssh  A-d kill ' \
        --no-sort --ansi --border-label ' GOOD BOY ' --prompt '  ' --border=rounded \
        --bind "tab:down,btab:up" \
        --bind "alt-1:change-prompt(  )+reload(tmux ls -F \"#S\" | tac)" \
        --bind "alt-2:change-prompt(  )+reload(zoxide query --list; find ~/repos -maxdepth 1)" \
        --bind "alt-3:change-prompt(  )+reload(echo -e \"$COMMAND\")" \
        --bind "alt-4:change-prompt(  )+reload(echo -e \"$SSH_HOSTS\")" \
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

if [[ "$CHOOSEN" == "[SSH]"* ]]; then
    CHOOSEN_NO_PREFIX="${CHOOSEN#\[SSH\] }"

    DATA=$(jq -r --arg host "$CHOOSEN_NO_PREFIX" '.[$host]' "$HOSTS_FILE")
    HOST=$(echo "$DATA" | jq -r '.host // empty')
    USER_CFG=$(echo "$DATA" | jq -r '.user // empty')
    PORT=$(echo "$DATA" | jq -r '.port // empty')
    KEY=$(echo "$DATA" | jq -r '.key // empty')
    PASSWORD_PATH_RAW=$(echo "$DATA" | jq -r '.password_file // empty')
    PASSWORD_PATH="${PASSWORD_PATH_RAW/#\~/$HOME}"
    PASSWORD=""

    if [ -n "$PASSWORD_PATH" ] && [ -f "$PASSWORD_PATH" ]; then
        PASSWORD=$(<"$PASSWORD_PATH")
    fi

    # fallback to current shell user if not set
    USER="${USER_CFG:-$USER}"

    if [ -z "$HOST" ]; then
        tmux display-message "SSH: missing host for $CHOOSEN_NO_PREFIX"
        exit 1
    fi

    # Build SSH command
    SSH_CMD="ssh -o ServerAliveInterval=15 -o ServerAliveCountMax=3"

    [ -n "$PORT" ] && SSH_CMD="$SSH_CMD -p $PORT"
    [ -n "$KEY" ] && SSH_CMD="$SSH_CMD -i $KEY"

    TARGET="$USER@$HOST"

    if [ -n "$PASSWORD" ] && [ -z "$KEY" ]; then
        if command -v sshpass >/dev/null 2>&1; then
            SSH_CMD="sshpass -e $SSH_CMD $TARGET"
        else
            tmux display-message "sshpass not installed"
            exit 1
        fi
    else
        SSH_CMD="$SSH_CMD $TARGET"
    fi

    # Open new window in CURRENT session
    # launch ssh with the sshpass env var
    tmux new-window -n "ssh:$CHOOSEN_NO_PREFIX" "SSHPASS=$(printf %q "$PASSWORD") zsh"
    tmux send-keys "$SSH_CMD" C-m

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
