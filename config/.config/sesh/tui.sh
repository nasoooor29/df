tmux send-keys -t 1 'bluetui' C-m

tmux new-window -t 2
tmux send-keys -t 2 'nmtui' C-m

tmux select-window -t 1
