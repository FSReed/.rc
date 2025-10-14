# For xv6 debug

function xvdbg {
    local SESSION_NAME="xv6"
    # Make sure xv6's path is set to ${HOME}/xv6
    local DIR="${HOME}/${SESSION_NAME}"
    if ! [[ -d ${DIR} ]]; then
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

# For yazi, cd to cwd after quit yazi. Very convenient!
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# run map-reduce, 1 worker 1 coordinator
function mr () {
  if [ $# -le 1 ]; then
    echo "Usage: mr [plugin] [files] [worker-nums=10]"
    return
  fi

  local SESSION_NAME="mr"
  local DIR="${HOME}/824/src/main"
  local SIGNAL="TLock"
  tmux has-session -t ${SESSION_NAME} 2> /dev/null
  if [ $? != 0 ]; then
      tmux new-session -d -s ${SESSION_NAME} -c ${DIR}
      tmux send-key -t ${SESSION_NAME}:0 "tmux wait -L ${SIGNAL}; go build -buildmode=plugin ../mrapps/$1.go; tmux wait -U $SIGNAL" C-m
      tmux send-key -t ${SESSION_NAME}:0 "go run mrcoordinator.go $2" C-m

      echo -en "Spawning the coordinator... "
      sleep 0.5 # Make sure the tmux session can acquire the lock first
      tmux wait-for -L $SIGNAL
      echo "Done!😋"
      sleep 1

      local worker_num=10
      if [ $# -eq 3 ]; then
        worker_num=$3
      fi

      for i in {1..$worker_num}; do
        tmux new-window -d -t ${SESSION_NAME} -c ${DIR} "go run mrworker.go $1.so"
      done
  fi
  tmux attach-session -t ${SESSION_NAME}
}
