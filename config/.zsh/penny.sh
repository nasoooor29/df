penny_tmux() {
  tmux split-window -h \; send-keys 'npm run penny' C-m \
    \; select-pane -L \; split-window -v \; send-keys 'npm run api' C-m \
    \; select-pane -D \; send-keys 'npm run workers' C-m \
    \; select-pane -U \; split-window -v \; send-keys 'npm run vendor' C-m \
    \; select-pane -R \; split-window -v \; send-keys 'cd scripts/docker-compose; sed -i "s/platform: linux\/arm64\/v8/platform: linux\/amd64/g" docker-compose.yaml; docker compose up' C-m \
    \; select-layout tiled
}
