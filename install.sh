#!/bin/bash

source ./scripts/utils.sh
source ./scripts/env.sh

set -e

# Ensure gum is available
GUM_PATH="$HOME/.local/share/dotty/bin/gum"
export PATH="$HOME/.local/share/dotty/bin:$PATH"
if [ ! -f "$GUM_PATH" ]; then
  echo "Gum binary not found. Installing gum..."
  mkdir -p $HOME/.local/share/dotty/bin
  cd $HOME/.local/share/dotty
  
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS installation
    if [[ $(uname -m) == "arm64" ]]; then
      curl -LO https://github.com/charmbracelet/gum/releases/download/v0.17.0/gum_0.17.0_Darwin_arm64.tar.gz
      tar -xzf gum_0.17.0_Darwin_arm64.tar.gz
      mv gum_0.17.0_Darwin_arm64/gum $HOME/.local/share/dotty/bin/
      rm -rf gum_0.17.0_Darwin_arm64 gum_0.17.0_Darwin_arm64.tar.gz
    else
      curl -LO https://github.com/charmbracelet/gum/releases/download/v0.17.0/gum_0.17.0_Darwin_x86_64.tar.gz
      tar -xzf gum_0.17.0_Darwin_x86_64.tar.gz
      mv gum_0.17.0_Darwin_x86_64/gum $HOME/.local/share/dotty/bin/
      rm -rf gum_0.17.0_Darwin_x86_64 gum_0.17.0_Darwin_x86_64.tar.gz
    fi
    chmod +x $HOME/.local/share/dotty/bin/gum
  else
    # Linux installation
    wget https://github.com/charmbracelet/gum/releases/download/v0.17.0/gum_0.17.0_Linux_x86_64.tar.gz
    tar -xzf gum_0.17.0_Linux_x86_64.tar.gz
    mv gum_0.17.0_Linux_x86_64/gum $HOME/.local/share/dotty/bin/
    chmod +x $HOME/.local/share/dotty/bin/gum
    rm -rf gum_0.17.0_Linux_x86_64 gum_0.17.0_Linux_x86_64.tar.gz
  fi
fi

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
  PLATFORM="mac"
else
  DISTRO=$(source /etc/os-release && echo "$ID")
  case "$DISTRO" in
  arch | endeavouros) PLATFORM="arch" ;;
  debian | ubuntu) PLATFORM="deb" ;;
  *)
    red "❌ Unsupported distro: $DISTRO"
    exit 1
    ;;
  esac
fi

echo "🎯 Detected platform: $PLATFORM"

# Dynamic categories and apps
CATEGORIES=$(find ./install/$PLATFORM -type f -name "*.sh" ! -name "[0-9][0-9]_*.sh" | awk -F'/' '{print $NF}' | awk -F'_' '{print $1}' | sort | uniq)
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

# Run preflight scripts in order
PREFLIGHT_SCRIPTS=$(find ./scripts -type f -name "preflight_*.sh" | sort)
for script in $PREFLIGHT_SCRIPTS; do
  blue "➡️  Running preflight script: $(basename $script)"
  bash "$script"
  green "✅ Completed: $(basename $script)"
done

# Run static scripts in order
STATIC_SCRIPTS=$(find ./install/$PLATFORM -type f -name "[0-9][0-9]_*.sh" | sort)
for script in $STATIC_SCRIPTS; do
  blue "➡️  Running static script: $(basename $script)"
  bash "$script"
  green "✅ Completed: $(basename $script)"
done

# Save profile before installation
if [ ${#SELECTED[@]} -gt 0 ]; then
  TIMESTAMP=$(date +%Y%m%d_%H%M%S)
  PROFILE_FILE="profiles/tmp_$TIMESTAMP.profile"
  
  echo "# Profile created on $(date)" > "$PROFILE_FILE"
  echo "PLATFORM=$PLATFORM" >> "$PROFILE_FILE"
  echo "SELECTED_SCRIPTS=(" >> "$PROFILE_FILE"
  for script in "${SELECTED[@]}"; do
    echo "  \"$script\"" >> "$PROFILE_FILE"
  done
  echo ")" >> "$PROFILE_FILE"
  
  blue "💾 Profile saved to: $PROFILE_FILE"
  
  # Ask if user wants to save as permanent profile
  if command -v gum >/dev/null 2>&1; then
    SAVE_PERMANENT=$($GUM_PATH confirm "Save this profile permanently?" && echo "yes" || echo "no")
    if [ "$SAVE_PERMANENT" = "yes" ]; then
      PROFILE_NAME=$($GUM_PATH input --placeholder "Enter profile name (without .profile extension)")
      if [ -n "$PROFILE_NAME" ]; then
        cp "$PROFILE_FILE" "profiles/${PROFILE_NAME}.profile"
        green "✅ Permanent profile saved as: profiles/${PROFILE_NAME}.profile"
      fi
    fi
  fi
fi

# Run selected scripts
for script in "${SELECTED[@]}"; do
  blue "➡️  Installing: $script"
  echo "Downloading app '$script' for distro '$PLATFORM' ..."
  echo "./install/$PLATFORM/$script.sh" >>installed_packages.log
  bash "./install/$PLATFORM/$script.sh"
  green "✅ Installed: $script"
done

# Run postflight scripts in order
POSTFLIGHT_SCRIPTS=$(find ./scripts -type f -name "postflight_*.sh" | sort)
for script in $POSTFLIGHT_SCRIPTS; do
  blue "➡️  Running postflight script: $(basename $script)"
  bash "$script"
  green "✅ Completed: $(basename $script)"
done

echo "✅ Installation complete!"
