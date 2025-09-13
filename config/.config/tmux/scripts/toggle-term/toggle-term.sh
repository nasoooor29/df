if [[ -z "$TMUX" ]]; then
    echo "This script must be run inside a Tmux session." >&2
    exit 1
fi

CURRENT_SESSION=$(tmux display-message -p '#S')
CURRENT_SESSION_PATH=$(tmux display-message -p -t :1 '#{pane_current_path}')
TERM_NAME="_COMMAND_TERM"
TERM_SESSION_NAME="${CURRENT_SESSION}${TERM_NAME}"

if [[ $CURRENT_SESSION != *"$TERM_NAME"* ]]; then
    tmux new-session -d -s $TERM_SESSION_NAME -c $CURRENT_SESSION_PATH
fi

toggle() {
    if [[ $CURRENT_SESSION == *"$TERM_NAME"* ]]; then
        close
    else
        open
    fi
}

open() {
    tmux popup -h 75% -w 90% -E "tmux attach-session -t $TERM_SESSION_NAME"
}

run() {
    if [[ -f "$CURRENT_SESSION_PATH/go.mod" ]]; then
        CMD="echo go code"
    elif [[ -f "$CURRENT_SESSION_PATH/package.json" ]]; then
        CMD="echo js code"
    else
        CMD="echo no code"
    fi

    if [[ $CURRENT_SESSION == *"$TERM_NAME"* ]]; then
        tmux send-keys -t $CURRENT_SESSION "$CMD" C-m
        return
    fi

    open
    tmux send-keys -t $TERM_SESSION_NAME "$CMD" C-m
}

close() {
    if [[ $CURRENT_SESSION != *"$TERM_NAME"* ]]; then
        return
    fi
    TERM_SESSION_NAME="${CURRENT_SESSION}"
    if tmux has-session -t "$TERM_SESSION_NAME" 2>/dev/null; then
        tmux detach-client -s $TERM_SESSION_NAME
    fi
}

if [[ $1 == "open" ]]; then
    open
fi

if [[ $1 == "close" ]]; then
    close
fi

if [[ $1 == "run" ]]; then
    run
fi

if [[ $1 == "toggle" ]]; then
    toggle
fi
