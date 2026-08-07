# we will make an empty variable for all the plugins as an associative array then fill it on the plugin func
typeset -A ALL_PLUGINS

plugin() {
    local repo=$1
    local activation=$2

    local name=${repo:t:r}
    local dir="$HOME/.zsh/$name"

    if [[ ! -d $dir ]]; then
        echo "Cloning $repo into $dir..."
        git clone "$repo" "$dir"
    fi

    # if there is an activation script, source it
    [[ -n $activation ]] && source "$dir/$activation"
    # we will add the plugin to the ALL_PLUGINS associative array with the name as key and the repo as value
    ALL_PLUGINS[$name]=$repo
}

update_zsh_plugins() {
    local name
    local dir

    for name in ${(k)ALL_PLUGINS}; do
        dir="$HOME/.zsh/$name"

        if [[ -d "$dir/.git" ]]; then
            echo "Updating $name..."
            git -C "$dir" pull --rebase --autostash
        else
            echo "Skipping $name: not a Git repository"
        fi
    done
}

plugin "https://github.com/romkatv/powerlevel10k.git" "powerlevel10k.zsh-theme"
plugin "https://github.com/zsh-users/zsh-autosuggestions.git" "zsh-autosuggestions.zsh"
plugin "https://github.com/jeffreytse/zsh-vi-mode.git" "zsh-vi-mode.plugin.zsh"
plugin "https://github.com/ptavares/zsh-direnv.git" "zsh-direnv.plugin.zsh"
plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "zsh-syntax-highlighting.zsh"
plugin "https://github.com/remcohaszing/zsh-node-bin.git" "node-bin.plugin.zsh"

source ~/.zsh/.p10k.zsh
autoload -Uz compinit
compinit

# my custom plugins
source ~/.zsh/my-plugins/sudo.sh
source ~/.zsh/my-plugins/extract.sh

