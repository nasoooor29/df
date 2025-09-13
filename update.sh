#!/bin/bash

set -e

source ./scripts/env.sh
source ./scripts/utils.sh
export INSTALL_NEEDED=""

if [ ! -f installed_packages.log ]; then
  echo "No installed scripts log found. Nothing to update."
  exit 0
fi

declare -A seen
while read -r script; do
  if [[ -z "$script" ]]; then
    continue
  fi
  if [[ -z "${seen[$script]}" ]]; then
    seen[$script]=1
    echo "Re-running $script..."
    bash "$script"
  fi
done <installed_packages.log

# Run postflight scripts in order
POSTFLIGHT_SCRIPTS=$(find ./scripts -type f -name "postflight_*.sh" | sort)
for script in $POSTFLIGHT_SCRIPTS; do
  blue "➡️  Running postflight script: $(basename $script)"
  bash "$script"
  green "✅ Completed: $(basename $script)"
done

echo "✅ All scripts re-executed!"
