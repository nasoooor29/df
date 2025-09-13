SCALE_FACTOR=$(hyprctl monitors | awk '/Monitor eDP-1/,/scale:/{if(/scale:/ && $2 != "") print $2}')
CLEANED_SCALE_FACTOR=$(echo "${SCALE_FACTOR[@]/#/}")
CLEANED_SCALE_FACTOR=$(echo "${CLEANED_SCALE_FACTOR[@]// /}")

if [ "$CLEANED_SCALE_FACTOR" == "1.00" ]; then
    hyprctl keyword monitor eDP-1,1920x1080@60,0x0,1
else
    hyprctl keyword monitor eDP-1,1920x1080@60,0x0,1
fi
