#!/bin/bash

source ./scripts/utils.sh

set -e

# Ensure gum is available
GUM_PATH="$HOME/.local/share/dotty/bin/gum"
export PATH="$HOME/.local/share/dotty/bin:$PATH"
if [ ! -f "$GUM_PATH" ]; then
  red "❌ Gum not found. Please run ./install.sh first to install gum."
  exit 1
fi

# Function to list profiles
list_profiles() {
  find ./profiles -type f -name "*.profile" 2>/dev/null | sed 's|./profiles/||' | sed 's|.profile$||' | grep -v "^tmp_" || true
}

list_temp_profiles() {
  find ./profiles -type f -name "tmp_*.profile" 2>/dev/null | sed 's|./profiles/||' | sed 's|.profile$||' || true
}

# Main menu
while true; do
  clear
  echo "🔧 Profile Management"
  echo
  
  ACTION=$($GUM_PATH choose --cursor.foreground="212" --item.foreground="250" --selected.foreground="34" --selected.background="212" \
    "List permanent profiles" \
    "List temporary profiles" \
    "Save temporary profile as permanent" \
    "Delete profile" \
    "View profile contents" \
    "Exit")
  
  case "$ACTION" in
    "List permanent profiles")
      echo
      blue "📋 Permanent profiles:"
      PROFILES=$(list_profiles)
      if [ -z "$PROFILES" ]; then
        yellow "⚠️  No permanent profiles found"
      else
        echo "$PROFILES"
      fi
      echo
      read -p "Press Enter to continue..."
      ;;
      
    "List temporary profiles")
      echo
      blue "📋 Temporary profiles:"
      TEMP_PROFILES=$(list_temp_profiles)
      if [ -z "$TEMP_PROFILES" ]; then
        yellow "⚠️  No temporary profiles found"
      else
        echo "$TEMP_PROFILES"
      fi
      echo
      read -p "Press Enter to continue..."
      ;;
      
    "Save temporary profile as permanent")
      TEMP_PROFILES=$(list_temp_profiles)
      if [ -z "$TEMP_PROFILES" ]; then
        yellow "⚠️  No temporary profiles found"
        read -p "Press Enter to continue..."
        continue
      fi
      
      echo
      SELECTED_TEMP=$($GUM_PATH choose --cursor.foreground="212" --item.foreground="250" --selected.foreground="34" --selected.background="212" $TEMP_PROFILES)
      
      if [ -n "$SELECTED_TEMP" ]; then
        PROFILE_NAME=$($GUM_PATH input --placeholder "Enter permanent profile name (without .profile extension)")
        if [ -n "$PROFILE_NAME" ]; then
          if [ -f "./profiles/${PROFILE_NAME}.profile" ]; then
            if $GUM_PATH confirm "Profile '$PROFILE_NAME' already exists. Overwrite?"; then
              cp "./profiles/${SELECTED_TEMP}.profile" "./profiles/${PROFILE_NAME}.profile"
              green "✅ Profile saved as: ${PROFILE_NAME}.profile"
            fi
          else
            cp "./profiles/${SELECTED_TEMP}.profile" "./profiles/${PROFILE_NAME}.profile"
            green "✅ Profile saved as: ${PROFILE_NAME}.profile"
          fi
        fi
      fi
      echo
      read -p "Press Enter to continue..."
      ;;
      
    "Delete profile")
      ALL_PROFILES=$(find ./profiles -type f -name "*.profile" 2>/dev/null | sed 's|./profiles/||' | sed 's|.profile$||' || true)
      if [ -z "$ALL_PROFILES" ]; then
        yellow "⚠️  No profiles found"
        read -p "Press Enter to continue..."
        continue
      fi
      
      echo
      SELECTED_DELETE=$($GUM_PATH choose --cursor.foreground="212" --item.foreground="250" --selected.foreground="34" --selected.background="212" $ALL_PROFILES)
      
      if [ -n "$SELECTED_DELETE" ]; then
        if $GUM_PATH confirm "Delete profile '$SELECTED_DELETE'?"; then
          rm -f "./profiles/${SELECTED_DELETE}.profile"
          green "✅ Profile deleted: ${SELECTED_DELETE}.profile"
        fi
      fi
      echo
      read -p "Press Enter to continue..."
      ;;
      
    "View profile contents")
      ALL_PROFILES=$(find ./profiles -type f -name "*.profile" 2>/dev/null | sed 's|./profiles/||' | sed 's|.profile$||' || true)
      if [ -z "$ALL_PROFILES" ]; then
        yellow "⚠️  No profiles found"
        read -p "Press Enter to continue..."
        continue
      fi
      
      echo
      SELECTED_VIEW=$($GUM_PATH choose --cursor.foreground="212" --item.foreground="250" --selected.foreground="34" --selected.background="212" $ALL_PROFILES)
      
      if [ -n "$SELECTED_VIEW" ]; then
        echo
        blue "📄 Contents of profile: $SELECTED_VIEW"
        cat "./profiles/${SELECTED_VIEW}.profile"
      fi
      echo
      read -p "Press Enter to continue..."
      ;;
      
    "Exit")
      green "👋 Goodbye!"
      exit 0
      ;;
  esac
done