#!/bin/bash
#  ██╗    ██╗ █████╗ ██╗     ██╗     ██████╗  █████╗ ██████╗ ███████╗██████╗
#  ██║    ██║██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
#  ██║ █╗ ██║███████║██║     ██║     ██████╔╝███████║██████╔╝█████╗  ██████╔╝
#  ██║███╗██║██╔══██║██║     ██║     ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
#  ╚███╔███╔╝██║  ██║███████╗███████╗██║     ██║  ██║██║     ███████╗██║  ██║
#   ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝
#
#  ██╗      █████╗ ██╗   ██╗███╗   ██╗ ██████╗██╗  ██╗███████╗██████╗
#  ██║     ██╔══██╗██║   ██║████╗  ██║██╔════╝██║  ██║██╔════╝██╔══██╗
#  ██║     ███████║██║   ██║██╔██╗ ██║██║     ███████║█████╗  ██████╔╝
#  ██║     ██╔══██║██║   ██║██║╚██╗██║██║     ██╔══██║██╔══╝  ██╔══██╗
#  ███████╗██║  ██║╚██████╔╝██║ ╚████║╚██████╗██║  ██║███████╗██║  ██║
#  ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#
#  Info    - This script runs the rofi launcher, to select
#            an svg and copy it to the clipboard.

# Set some variables
svg_dir="${HOME}/.config/rofi/devicon/icons"
cacheDir="${HOME}/.cache/rofi-svg"
rofi_command="rofi -dmenu -theme ${HOME}/.config/rofi/svg-select.rasi"

# Create cache dir if not exists
if [ ! -d "${cacheDir}" ]; then
    mkdir -p "${cacheDir}"
fi

# --- Caching function ---
cache_images() {
    find "${svg_dir}" -type f -iname "*.svg" | while read -r imagen;
        do
        nombre_archivo=$(basename "$imagen" .svg)
        if [ ! -f "${cacheDir}/${nombre_archivo}.png" ]; then
            magick convert -background none -resize 256x256 "$imagen" "${cacheDir}/${nombre_archivo}.png"
        fi
    done
}

# --- Main script ---

# Run caching in the background
cache_images &

# Select an svg with rofi
svg_selection=$(find "${svg_dir}" -type f -iname "*.svg" | sort | while read -r A;
    do
    nombre_archivo=$(basename "$A" .svg)
    echo -en "$(basename "$A")\x00icon\x1f""${cacheDir}""/${nombre_archivo}.png\n"
done | $rofi_command)


# Copy the svg to the clipboard
if [[ -n "${svg_selection}" ]]; then
    svg_path=$(find "${svg_dir}" -type f -iname "${svg_selection}")
    cat "${svg_path}" | wl-copy
    notify-send "Copied to clipboard" "${svg_selection}"
fi

exit 0