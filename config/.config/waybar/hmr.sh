inotifywait -m -e modify,create,delete "$HOME/.config/waybar" | while read -r; do
    echo "Waybar config changed. Restarting..."
    pkill waybar
    waybar &
done
