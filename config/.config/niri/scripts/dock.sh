# if ! lsusb | grep -q 046d:c08b; then

# if the 046d:c08b device exists then it's on the dock, otherwise it's on the laptop

function is_docked() {
    if lsusb | grep -q 046d:c08b; then
        return 0 # Device is on the dock
    else
        return 1 # Device is on the laptop
    fi
}
