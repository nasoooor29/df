# Define an array of extensions with paths, repos, and activation files

# Function to update all Zsh extensions
update_zsh() {
  for entry in "${ext[@]}"; do
    # Split the entry into components
    IFS='|' read -r dir repo activate <<<"$entry"

    # Update the extension if the directory exists
    if [[ -d $dir ]]; then
      echo "Updating $dir..."
      git -C "$dir" pull --rebase || echo "Failed to update $dir"
    else
      echo "$dir does not exist, skipping."
    fi
  done
}

# if you want to add new ext make sure the next new line will be like
# <install location>|<git link>|<activation script>
ext=(
  "$HOME/.zsh/powerlevel10k|https://github.com/romkatv/powerlevel10k|$HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme"
  "$HOME/.zsh/zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions.git|$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
  "$HOME/.zsh/zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting.git|$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  "$HOME/.zsh/supercharge|https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/supercharge.git|$HOME/.zsh/supercharge/supercharge.plugin.zsh"
  "$HOME/.zsh/zsh-vi-mode|https://github.com/jeffreytse/zsh-vi-mode.git|$HOME/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
)

# Loop through the array
for entry in "${ext[@]}"; do
  # Split the entry into components
  IFS='|' read -r dir repo activate <<<"$entry"

  # Check if the directory exists, clone if necessary
  if [[ ! -d $dir ]]; then
    echo "Cloning $repo into $dir..."
    git clone "$repo" "$dir"
  fi

  # Source the activation file if it exists
  if [[ -f $activate ]]; then
    # echo "Sourcing $activate..."
    source "$activate"
  else
    echo "Activation file $activate not found."
  fi
done

source ~/.zsh/.p10k.zsh
autoload -Uz compinit
compinit



# my custom plugins
source ~/.zsh/my-plugins/sudo/plugin.sh
