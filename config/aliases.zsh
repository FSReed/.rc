CONFIG_DIR="${HOME}"/.rc/config

alias R='source ~/.zshrc'
alias mzsh='nvim "${CONFIG_DIR}"/.zshrc'
alias malias='nvim "${CONFIG_DIR}"/aliases.zsh'
alias mfunc='nvim "${CONFIG_DIR}"/functions.zsh'

# For Git
alias ga='git add .'
alias gs='git status'
alias gc='git commit'
alias gpo='git push origin'
alias gl='git log --graph --oneline'

