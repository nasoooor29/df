penny_tmux() {
  tmux split-window -h \; send-keys 'npm run penny' C-m \
    \; select-pane -L \; split-window -v \; send-keys 'npm run api' C-m \
    \; select-pane -D \; send-keys 'npm run workers' C-m \
    \; select-pane -U \; split-window -v \; send-keys 'npm run vendor' C-m \
    \; select-pane -R \; split-window -v \; send-keys 'npm run vendor-login' C-m \
    \; split-window -v \; send-keys 'cd scripts/docker-compose; sed -i "s/platform: linux\/arm64\/v8/platform: linux\/amd64/g" docker-compose.yaml; docker compose up' C-m \
    \; select-layout tiled
}
p () {
  name="$1"
  if [ -z "$name" ]; then
    echo "Usage: p <name>" >&2
    return 0
  fi
  prev_path=$(pwd)
  zoxide add ~/Desktop/dev/*
  q=$(zoxide query "$name")
  cd "$q" || return
  echo "Changed directory to: $q"
  code .
  cd "$prev_path" || return
}

penny_worktree() {
  # Set the original repo path
  original_repo="/Users/naser/Desktop/dev/penny"

  # Check for at least two arguments: at least one branch and the original branch
  if [ "$#" -lt 2 ]; then
    echo "Usage: penny_worktree <new-branch-name> [<new-branch-name> ...] <original-branch>" >&2
    return 0
  fi

  # Get the original branch (last argument)
  original_branch="${@: -1}"

  # Get all arguments except the last one
  branch_args=("${@:1:$(($#-1))}")
  
  # Loop through all branch names except the last argument
  for branch_name in "${branch_args[@]}"; do
    # Construct the worktree path
    worktree_path="../${branch_name//\//-}"
    echo "[INFO] Worktree path will be: $worktree_path"

    # Fetch the original branch from origin using the original repo
    echo "[INFO] Fetching '$original_branch' from origin in $original_repo..."
    git -C "$original_repo" fetch origin "$original_branch"

    # Create the new branch from origin/$original_branch if it doesn't exist
    if ! git -C "$original_repo" show-ref --verify --quiet "refs/heads/$branch_name"; then
      echo "[INFO] Creating branch '$branch_name' from 'origin/$original_branch'..."
      git -C "$original_repo" branch "$branch_name" "origin/$original_branch"
    else
      echo "[INFO] Branch '$branch_name' already exists."
    fi

    # Add the worktree for the new branch
    echo "[INFO] Adding worktree at '$worktree_path' for branch '$branch_name'..."
    git -C "$original_repo" worktree add "$worktree_path" "$branch_name"

    # Copy necessary files
    echo "[INFO] Linking node_modules..."
    ln -sf "$original_repo/node_modules" "$worktree_path/node_modules"
    echo "[INFO] Copying base.env (docker-compose)..."
    mkdir -p "$worktree_path/scripts/docker-compose"
    cp "$original_repo/scripts/docker-compose/base.env" "$worktree_path/scripts/docker-compose/base.env"
    echo "[INFO] Copying base.env (libs/environments)..."
    mkdir -p "$worktree_path/libs/environments/src/lib/base/env"
    cp "$original_repo/libs/environments/src/lib/base/env/base.env" "$worktree_path/libs/environments/src/lib/base/env/base.env"

    echo "[INFO] running: code $worktree_path"
    code "$worktree_path"
  done
}

