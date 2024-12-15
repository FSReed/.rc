CONFIG_DIR='${HOME}/.rc/config'

alias R='source ~/.zshrc'
alias mzsh='nvim ${CCONFIG_DIR}/.zshrc'
alias malias='nvim ${CONFIG_DIR}/aliases.zsh'

# For Git
alias ga='git add .'
alias gs='git status'
alias gc='git commit'
alias gpo='git push origin'
alias gl='git log --graph --oneline'

# For xv6 debug
xvdbg () {
        local SESSION_NAME="xv6"
        local DIR="${HOME}/${SESSION_NAME}"
        tmux has-session -t ${SESSION_NAME} 2> /dev/null
        if [ $? != 0 ]
        then
                tmux new-session -d -s ${SESSION_NAME} -c ${DIR}
                tmux split-window -h -t ${SESSION_NAME}:0 -c ${DIR}
                tmux send-key -t ${SESSION_NAME}:0.0 'make CPUS=1 qemu-gdb' C-m
                tmux send-key -t ${SESSION_NAME}:0.1 'gdb-multiarch' C-m
        fi
        tmux attach-session -t ${SESSION_NAME}
}

