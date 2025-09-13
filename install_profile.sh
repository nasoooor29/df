#!/bin/bash

source ./scripts/utils.sh
source ./scripts/env.sh

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

# Function to list available profiles
list_profiles() {
  find ./profiles -type f -name "*.profile" 2>/dev/null | sed 's|./profiles/||' | sed 's|.profile$||'
}

# Check if profiles directory exists and has profiles
if [ ! -d "./profiles" ] || [ -z "$(list_profiles)" ]; then
  red "❌ No profiles found in ./profiles directory"
  echo "Create a profile by running ./install.sh first"
  exit 1
fi

# Let user select a profile
echo "📋 Available profiles:"
PROFILES=$(list_profiles)
SELECTED_PROFILE=$($GUM_PATH choose --cursor.foreground="212" --item.foreground="250" --selected.foreground="34" --selected.background="212" $PROFILES)

if [ -z "$SELECTED_PROFILE" ]; then
  yellow "⚠️  No profile selected. Exiting..."
  exit 0
fi

PROFILE_FILE="./profiles/${SELECTED_PROFILE}.profile"

# Load the profile
blue "📥 Loading profile: $SELECTED_PROFILE"
source "$PROFILE_FILE"

# Verify platform compatibility
CURRENT_DISTRO=$(source /etc/os-release && echo "$ID")
case "$CURRENT_DISTRO" in
arch | endeavouros) CURRENT_PLATFORM="arch" ;;
debian | ubuntu) CURRENT_PLATFORM="deb" ;;
*)
  red "❌ Unsupported distro: $CURRENT_DISTRO"
  exit 1
  ;;
esac

if [ "$PLATFORM" != "$CURRENT_PLATFORM" ]; then
  red "❌ Profile platform mismatch!"
  echo "Profile platform: $PLATFORM"
  echo "Current platform: $CURRENT_PLATFORM"
  exit 1
fi

echo "🎯 Profile platform: $PLATFORM"
echo "📦 Scripts to install: ${SELECTED_SCRIPTS[*]}"

# Ask for confirmation
if ! $GUM_PATH confirm "Install these scripts?"; then
  yellow "⚠️  Installation cancelled"
  exit 0
fi

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

# Run selected scripts from profile
for script in "${SELECTED_SCRIPTS[@]}"; do
  SCRIPT_PATH="./install/$PLATFORM/$script.sh"
  
  if [ ! -f "$SCRIPT_PATH" ]; then
    red "❌ Script not found: $SCRIPT_PATH"
    continue
  fi
  
  blue "➡️  Installing: $script"
  echo "Installing app '$script' from profile '$SELECTED_PROFILE' ..."
  echo "$SCRIPT_PATH" >>installed_packages.log
  bash "$SCRIPT_PATH"
  green "✅ Installed: $script"
done

# Run postflight scripts in order
POSTFLIGHT_SCRIPTS=$(find ./scripts -type f -name "postflight_*.sh" | sort)
for script in $POSTFLIGHT_SCRIPTS; do
  blue "➡️  Running postflight script: $(basename $script)"
  bash "$script"
  green "✅ Completed: $(basename $script)"
done

green "✅ Profile installation complete!"
