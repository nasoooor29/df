gwt() {
  if [ -z "$1" ]; then
    echo "Usage: gwt <branch-name>" >&2
    return 1
  fi
  branch="$1"
  project=$(basename "$(git rev-parse --show-toplevel)")
  dir="../${project}-${branch}"

  # Check if worktree already exists
  if git worktree list | grep -q " $dir "; then
    read -p "Worktree at $dir exists. Delete it? [y/N]: " yn
    if [[ $yn =~ ^[Yy]$ ]]; then
      git worktree remove "$dir"
    else
      echo "Aborted."
      return 1
    fi
  fi

  # Check if branch exists
  if git show-ref --verify --quiet refs/heads/$branch; then
    echo -n "Branch $branch exists. Delete it? [y/N]: "
    read yn
    if [[ $yn =~ ^[Yy]$ ]]; then
      git branch -D "$branch"
    else
      echo "Aborted."
      return 1
    fi
  fi

  git worktree add "$dir" -b "$branch"
  echo "Created worktree at $dir for branch $branch."
}

