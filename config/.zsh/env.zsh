export RUN_CMD="clear; go run ."
export EDITOR='nvim'
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:$(go env GOPATH)/bin
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/dotfiles/.zsh/scripts:$PATH"
export PATH=$PATH:"~/.zsh/scripts"
export GTK_THEME=Adwaita:dark
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
export QT_STYLE_OVERRIDE=Adwaita-Dark

loadenv() {
    set -a
    source "${1:-.env}"
    set +a
}

loadMasterEnv() {
    loadenv "$HOME/.zsh/.env"
}

HISTFILE="$HOME/.zsh_history"

HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
