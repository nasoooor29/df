CONFIG="$HOME/.config/wofi/config"
STYLE="$HOME/.config/wofi/themes/mocha.css"
wofii() {
    wofi --conf "$CONFIG" --style "$STYLE" "$@"
}
