# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


bindkey -e

source ~/.zsh/alias.zsh
source ~/.zsh/ext.zsh
source ~/.zsh/env.zsh
source ~/.zsh/penny.sh


export EDITOR='nvim'

export PATH=$PATH:"~/.zsh/scripts"


export GTK_THEME=Adwaita:dark
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
export QT_STYLE_OVERRIDE=Adwaita-Dark



eval "$(zoxide init --cmd cd zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/nasoooor/.miniconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/nasoooor/.miniconda/etc/profile.d/conda.sh" ]; then
        . "/home/nasoooor/.miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/home/nasoooor/.miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="/home/nasoooor/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/nasoooor/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
bindkey -v

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export BROWSER=google-chrome

source ~/.zsh/fzf.zsh


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/nasoooor/.GCP/google-cloud-sdk/path.zsh.inc' ]; then . '/home/nasoooor/.GCP/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/nasoooor/.GCP/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/nasoooor/.GCP/google-cloud-sdk/completion.zsh.inc'; fi
