#!/bin/bash

set -e

source ./scripts/env.sh
export INSTALL_NEEDED=""

if [ ! -f installed_packages.log ]; then
  echo "No installed scripts log found. Nothing to update."
  exit 0
fi

while read -r script; do
  echo "Re-running $script..."
  bash "$script"
done <installed_packages.log

echo "✅ All scripts re-executed!"
