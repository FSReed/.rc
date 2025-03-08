export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
plugins=(
    git
    fzf
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-you-should-use
    command-not-found
)

source $HOME/.profile
source $ZSH/oh-my-zsh.sh

