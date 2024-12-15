function xvdbg {
    local SESSION_NAME="xv6"
    # Make sure xv6's path is set to ${HOME}/xv6
    local DIR="${HOME}/${SESSION_NAME}"
    if ! [[ -f ${DIR} ]]; then
        echo -e "No xv6 repo found"
        return
    fi
    tmux has-session -t ${SESSION_NAME} 2> /dev/null
    if [ $? != 0 ]; then
            tmux new-session -d -s ${SESSION_NAME} -c ${DIR}
            tmux split-window -h -t ${SESSION_NAME}:0 -c ${DIR}
            tmux send-key -t ${SESSION_NAME}:0.0 'make CPUS=1 qemu-gdb' C-m
            tmux send-key -t ${SESSION_NAME}:0.1 'gdb-multiarch' C-m
    fi
    tmux attach-session -t ${SESSION_NAME}
}
