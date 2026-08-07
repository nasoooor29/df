# function to re-run last command with sudo
sudo_last() {
  if [[ -n "$BUFFER" ]]; then
    BUFFER="sudo $BUFFER"
    zle accept-line
  elif [[ -n "$history[1]" ]]; then
    BUFFER="sudo $(fc -ln -1)"
    zle accept-line
  fi
}

# bind to a key (Alt+g here)
zle -N sudo_last
bindkey '^[g' sudo_last
bindkey -M viins '^[g' sudo_last

# bind to a key (Ctrl+g here)
zle -N sudo_last
bindkey '^G' sudo_last
bindkey -M viins '^G' sudo_last
