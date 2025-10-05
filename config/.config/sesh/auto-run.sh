if [[ "$(pwd)" == "$HOME/repos" ]]; then
    exit 0
fi


if [[ "$(pwd)" =~ ^$HOME/Desktop/dev/ ]]; then
    code "$(pwd)"
    tmux new-window -t 2
    tmux send-keys -t 1 'penny_tmux' C-m
    exit 0
fi

if [[ "$(pwd)" == "$HOME/repos"* ]]; then
    tmux new-window -t 2
    tmux new-window -t 3
    tmux send-keys -t 3 'lazygit' C-m
    tmux select-window -t 1
    nvim
    exit 0
fi

if [[ "$(pwd)" == "$HOME/penny"* ]]; then
    tmux new-window -t 2
    tmux new-window -t 3
    tmux send-keys -t 3 'lazygit' C-m
    tmux select-window -t 1
    nvim
    exit 0
fi

if [[ "$(pwd)" == "$HOME/.config"* || "$(pwd)" == "$HOME/dotfiles"* ]]; then
    tmux new-window -t 2
    tmux select-window -t 1
    nvim
    exit 0
fi

