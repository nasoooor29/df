#!/bin/bash

set -e
source ./scripts/utils.sh

# Ensure gum is available
GUM_PATH="$HOME/.local/share/dotty/bin/gum"
export PATH="$HOME/.local/share/dotty/bin:$PATH"
if [ ! -f "$GUM_PATH" ]; then
  echo "Gum binary not found. Installing gum..."
  mkdir -p $HOME/.local/share/dotty
  mkdir -p $HOME/.local/share/dotty/bin
  cd $HOME/.local/share/dotty
  wget https://github.com/charmbracelet/gum/releases/download/v0.17.0/gum_0.17.0_Linux_x86_64.tar.gz
  tar -xzf gum_0.17.0_Linux_x86_64.tar.gz
  mv gum_0.17.0_Linux_x86_64/gum $HOME/.local/share/dotty/bin/
  chmod +x gum
  rm -rf gum_0.17.0_Linux_x86_64 gum_0.17.0_Linux_x86_64.tar.gz
fi

# Display banner
echo "   ██████   ██████   ██████  ████████            █  ██████  █████████  "
echo "  ███    ███ ███    ███ ███    ███ ███   ███          ███ ███    ███   ███    ███ "
echo "  ███    █  ███    ███ ███    ███ ███    ███          ███ ███    ███   ███    ███ "
echo " ███        ███    ███ ███    ███ ███    ███          ███ ███    ███  ████████  "
echo "███ ██████  ███    ███ ███    ███ ███    ███          ███ ███    ███ ████████  "
echo "  ███    ███ ███    ███ ███    ███ ███   ███          ███ ███    ███   ███    █  "
echo "  ████████   ████████   ████████  ████████       █ █████  ████████  █████████  "
echo "                                                   ██████                          "

# Choose sync method
SYNC_METHOD=$($GUM_PATH choose "copy" "symlink" "stow" "bare" "none")
blue "🔄 Sync method: $SYNC_METHOD"

# Sync configs
bash ./sync/sync.sh "$SYNC_METHOD" ./config "$HOME/.config"

# Proceed to installation
if $GUM_PATH confirm --default=false "🚀 Continue to software installation?"; then
  bash ./install.sh
else
  green "✅ Done."
fi
echo "🔄 Proceeding to installation: $CONTINUE"
if [ "$CONTINUE" = true ]; then
  bash ./install.sh
else
  green "✅ Done."
fi
