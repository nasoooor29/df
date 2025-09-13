#!/bin/bash

# Base directory for your projects and playgrounds
BASE_DIR="$HOME/repos/playground"
rm -rf "${BASE_DIR:?}/*"

BASE_PLAGROUND="$HOME/dotfiles/.config/tmux/scripts/playground"
PLAYGROUND_LANGS="$BASE_PLAGROUND/langs"
SESSION_NAME="playground"

display() {
    "$BASE_PLAGROUND/display.sh" "$@"
}
ask() {
    "$BASE_PLAGROUND/ask.sh" "$@"
}
ask_choice() {
    "$BASE_PLAGROUND/ask-choice.sh" "$@"
}

if [[ ! -d $BASE_DIR ]]; then
    # display "please clone your repo"
    mkdir -p "$BASE_DIR"
    exit 0 # it's exit 1 but just to shut tmux
fi

COMMAND=${1:-$(ask_choice "Select a branch" "new" "clear" $(ls "$BASE_DIR"))}

if [[ -z "$COMMAND" ]]; then
    exit 0
fi

if [ "$COMMAND" == "new" ]; then
    PROJECT_NAME=$(ask "Playground name")
    if [[ -z $PROJECT_NAME ]]; then
        display "Please give valid name"
        exit 0 # it's exit 1 but just to shut tmux
    fi

    if [[ -d "$BASE_DIR/$PROJECT_NAME" ]]; then
        display "Project already exists"
        exit 0 # it's exit 1 but just to shut tmux
    fi

    PG_LANG_SCRIPT=$(ask_choice "Select a lang" "$(ls "$PLAYGROUND_LANGS")")
    if [[ -z $PG_LANG_SCRIPT ]]; then
        display "Please select invalid language"
        exit 0 # it's exit 1 but just to shut tmux
    fi

    PROJECT_DIR="$BASE_DIR/$PROJECT_NAME"
    mkdir -p "$PROJECT_DIR" || exit
    sesh connect "$BASE_DIR/$PROJECT_NAME"
    cd $PROJECT_DIR || exit
    # cd "$BASE_DIR" || exit
    # redirect error to logs  playground[unix time].log
    bash "$PLAYGROUND_LANGS/$PG_LANG_SCRIPT" $PROJECT_NAME >"/tmp/playground_$(date +%s).log" &
    disown
    if [[ $? -ne 0 ]]; then
        exit 0 # it's exit 1 but just to shut tmux
    fi

elif [ "$COMMAND" = "clear" ]; then
    PROJECT_NAME=$(ask "Are you sure (YES)?")
    if [[ "$PROJECT_NAME" != "YES" ]]; then
        display "come when you are sure"
        exit 0 # it's exit 1 but just to shut tmux
    fi
    things=$(ls "$BASE_DIR")
    rm -rf "$BASE_DIR"/* >/dev/null
    display "Playground cleared"
    exit 0
else
    sesh connect "$BASE_DIR/$COMMAND" >/dev/null
    cd "$BASE_DIR" || exit
    exit 0
fi
