CONFIG_DIR="${HOME}"/.rc/config

alias R='source ~/.zshrc; source ~/.profile'
alias mzsh='nvim "${CONFIG_DIR}"/.zshrc'
alias malias='nvim "${CONFIG_DIR}"/aliases.zsh'
alias mfunc='nvim "${CONFIG_DIR}"/functions.zsh'

# For Git
alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gpo='git push origin'
alias gl='git log --graph --oneline'

# For cmake
alias cbuild='cmake -S . -B build && cmake --build build'
alias cmtest='cmake --build build --target'

# For Neovide
alias nide='neovide.exe --wsl --neovim-bin $(which nvim)'

# For conda
alias condaa='conda activate'
alias condad='conda deactivate'

