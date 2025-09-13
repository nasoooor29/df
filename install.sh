#!/bin/bash

source ./scripts/utils.sh

set -e

# Ensure gum is available
GUM_PATH="$HOME/.local/share/dotty/bin/gum"
export PATH="$HOME/.local/share/dotty/bin:$PATH"
if [ ! -f "$GUM_PATH" ]; then
  echo "Gum binary not found. Installing gum..."
  mkdir -p $HOME/.local/share/dotty
  cd $HOME/.local/share/dotty
  wget https://github.com/charmbracelet/gum/releases/download/v0.17.0/gum_0.17.0_Linux_x86_64.tar.gz
  tar -xzf gum_0.17.0_Linux_x86_64.tar.gz
  mv gum_0.17.0_Linux_x86_64/gum $HOME/.local/share/dotty/bin/
  chmod +x gum
  rm -rf gum_0.17.0_Linux_x86_64 gum_0.17.0_Linux_x86_64.tar.gz
fi

# Detect distro
DISTRO=$(source /etc/os-release && echo "$ID_LIKE")
case "$DISTRO" in
arch | endeavouros) PLATFORM="arch" ;;
debian | ubuntu) PLATFORM="deb" ;;
*)
  red "❌ Unsupported distro: $DISTRO"
  exit 1
  ;;
esac

echo "🎯 Detected platform: $PLATFORM"

# Dynamic categories and apps
CATEGORIES=$(find ./install/$PLATFORM -type f -name "*.sh" | awk -F'/' '{print $NF}' | awk -F'_' '{print $1}' | sort | uniq)
SELECTED=()

while true; do
  clear
  echo "Currently selected apps: ${SELECTED[*]}"
  clear
  echo "Currently selected apps: ${SELECTED[*]}"
  MAIN_CHOICE=$($GUM_PATH choose --cursor.foreground="212" --item.foreground="250" --selected.foreground="34" --selected.background="212" "Proceed" "Exit" $CATEGORIES)

  if [ -z "$MAIN_CHOICE" ]; then
    continue
  fi

  if [ "$MAIN_CHOICE" = "Proceed" ]; then
    break
  fi

  if [ "$MAIN_CHOICE" = "Exit" ]; then
    exit 0
  fi

  APPS=$(find ./install/$PLATFORM -type f -name "${MAIN_CHOICE}_*.sh" | awk -F'/' '{print $NF}' | sed 's/.sh$//')
  UNSELECTED_APPS=$(comm -23 <(echo "$APPS" | tr ' ' '\n' | sort) <(echo "${SELECTED[*]}" | tr ' ' '\n' | sort))

  if [ -z "$UNSELECTED_APPS" ]; then
    echo "All apps in $MAIN_CHOICE are already selected. Showing selected apps to deselect."
    UNSELECTED_APPS="$APPS"
  fi

  CHOSEN=$($GUM_PATH choose --no-limit --cursor.foreground="212" --item.foreground="250" --selected.foreground="34" --selected.background="212" $UNSELECTED_APPS)

  for APP in $CHOSEN; do
    if [[ " ${SELECTED[*]} " =~ " $APP " ]]; then
      SELECTED=(${SELECTED[@]/$APP/})
    else
      SELECTED+=($APP)
    fi
  done
done

# Run selected scripts
for script in "${SELECTED[@]}"; do
  blue "➡️  Installing: $script"
  echo "Downloading app '$script' for distro '$PLATFORM' ..."
  bash "./install/$PLATFORM/$script.sh"
  green "✅ Installed: $script"
done

echo "✅ Installation complete!"
