#!/bin/bash

# Postflight script to reboot the system
if gum confirm "Do you want to reboot the system now?"; then
  echo "Rebooting the system..."
  sudo reboot
else
  echo "Reboot skipped."
fi