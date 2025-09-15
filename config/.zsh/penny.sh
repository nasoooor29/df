penny_tmux() {
  tmux split-window -h \; send-keys 'npm run penny' C-m \
    \; select-pane -L \; split-window -v \; send-keys 'npm run api' C-m \
    \; select-pane -D \; send-keys 'npm run workers' C-m \
    \; select-pane -U \; split-window -v \; send-keys 'npm run vendor' C-m \
    \; select-pane -R \; split-window -v \; send-keys 'cd scripts/docker-compose; sed -i "s/platform: linux\/arm64\/v8/platform: linux\/amd64/g" docker-compose.yaml; docker compose up' C-m \
    \; select-layout tiled
}
penny_worktree() {
  # Set the original repo path
  original_repo=~/repos/penny

  # Get the branch name from the first CLI argument
  branch_name="$1"
  if [ -z "$branch_name" ]; then
    echo "Error: branch name is required." >&2
    exit 1
  fi

  # Construct the branch name
  worktree_path="../${branch_name//\//-}"
  echo "[INFO] Worktree path will be: $worktree_path"

  # Create the branch from develop
  echo "[INFO] Fetching 'develop' from origin..."
  git fetch origin develop
  echo "[INFO] Creating branch '$branch_name' from 'origin/develop'..."
  git branch "$branch_name" origin/develop

  # Add the worktree for the new branch
  echo "[INFO] Adding worktree at '$worktree_path' for branch '$branch_name'..."
  git worktree add "$worktree_path" "$branch_name"

  # Copy necessary files
  echo "[INFO] Copying node_modules..."
  cp "$original_repo/node_modules" "$worktree_path/node_modules" -r
  echo "[INFO] Copying base.env (docker-compose)..."
  cp "$original_repo/scripts/docker-compose/base.env" "$worktree_path/scripts/docker-compose/base.env"
  echo "[INFO] Copying base.env (libs/environments)..."
  cp "$original_repo/libs/environments/src/lib/base/env/base.env" "$worktree_path/libs/environments/src/lib/base/env/base.env"

  # echo "[INFO] Connecting to new worktree session at '$worktree_path'..."
  sesh connect "$worktree_path"
}
