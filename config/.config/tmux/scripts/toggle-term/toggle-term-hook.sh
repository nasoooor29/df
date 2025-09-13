CURRENT_SESSION=$(tmux display-message -p '#S')
TERM_NAME="_COMMAND_TERM"

if [[ $CURRENT_SESSION == *"$TERM_NAME"* ]]; then
    exit 0
fi
