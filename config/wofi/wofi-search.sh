#!/bin/bash

source "$HOME/.config/wofi/source-me.sh"
# Define search engines
declare -A SEARCH_ENGINES=(
  ["Google"]="https://www.google.com/search?q="
  ["Amazon"]="https://www.amazon.com/s?k="
  ["NPM"]="https://www.npmjs.com/search?q="
  ["GitHub"]="https://github.com/search?q="
  ["DuckDuckGo"]="https://duckduckgo.com/?q="
  ["Wikipedia"]="https://en.wikipedia.org/wiki/Special:Search?search="
)

ENGINE=$(printf "%s\n" "${!SEARCH_ENGINES[@]}" | wofi --conf "$CONFIG" --style "$STYLE" --dmenu --prompt "Select Search Engine")

[[ -z "$ENGINE" ]] && exit 1

# Check if the engine is on the list
if [[ -n "${SEARCH_ENGINES[$ENGINE]}" ]]; then

  QUERY=$(wofi --conf "$CONFIG" --style "$STYLE" --dmenu --prompt "Enter search query")

  [[ -z "$QUERY" ]] && exit 1

  xdg-open "${SEARCH_ENGINES[$ENGINE]}${QUERY// /+}"

else
  xdg-open "${SEARCH_ENGINES["Google"]}${ENGINE// /+}"
fi
