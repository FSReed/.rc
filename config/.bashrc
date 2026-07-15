# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

PS1='\[\033]0;$PWD\007\]' # set window title
PS1="$PS1"'\[\033[55m\]'
PS1="$PS1"'\[\033[95m\]'       # change to green
PS1="$PS1""\n===🔥 Working On: \h 🔥===\n"
PS1="$PS1"'Command \# '             # user@host<space>
PS1="$PS1"'\e[1;36m'
PS1="$PS1"'@\u \A\n'
PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
PS1="$PS1"'\w '                 # current working directory
PS1="$PS1"'\[\033[91m\]'        # change color
PS1="$PS1"'>'                 # prompt: not $ anymore
PS1="$PS1"'\[\033[92m\]'
PS1="$PS1"'>'
PS1="$PS1"'\[\033[94m\]'
PS1="$PS1"'>'
PS1="$PS1"'\[\033[0m\] '

alias R='source ~/.bashrc'
alias mbash='nvim ~/.rc/config/.bashrc'
alias mvim='cd ~/AppData/Local/nvim; nvim'

# For Git
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gpo='git push origin'
alias gl='git log --graph --oneline'
alias gr='git remote'
alias gs='git status'
alias gst='git stash'
alias gstp='git stash pop'

# For Yazi
export YAZI_CONFIG_HOME=~/AppData/Roaming/yazi/
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# For UE
DotnetPath='/d/UE/UE_5.4/Engine/Binaries/ThirdParty/DotNet/6.0.302/windows/dotnet.exe'
UBTPath='D:\UE\UE_5.4\Engine\Binaries\DotNET\UnrealBuildTool\UnrealBuildTool.dll'
UEnginePath='D:\UE\UE_5.4'
UEProjPath='D:\UE\Projects'
UEProjBashPath='/d/UE/Projects'

# Usage: UEClang <proj_name>
function UEClang() {
  if [[ $# < 1 ]]; then
    echo "Usage: UEClang [project-name]"
    return 0
  fi
  local proj="${UEProjPath}\\$1\\$1.uproject"
  local target="$1Editor"
  ${DotnetPath} ${UBTPath} -mode=GenerateClangDatabase -project=${proj} -game -engine ${target} Win64 Development
  if [[ $? != 0 ]]; then
    echo "Failed to generate compile_commands.json"
    return -1
  fi
  cp "${UEnginePath}\compile_commands.json" "${UEProjPath}\\$1\compile_commands.json"
}

# Usage: UEBuild <proj_name>
function UEBuild() {
  if [[ $# < 1 ]]; then
    echo "Usage: UEClang [project-name] [launch?]"
    return 0
  fi
  echo -en "Launch the editor after build? [Press 'N' as No]: "
  read AUTO
  local proj="${UEProjPath}\\$1\\$1.uproject"
  local target="$1Editor"
  ${DotnetPath} ${UBTPath} ${target} Win64 Development -Project=${proj} -WaitMutex -FromMsBuild -architecture=x64
  if [[ $? != 0 ]]; then
    echo "Build failed"
    return -1
  fi
  if [[ ${AUTO} == 'n' || ${AUTO} == 'N' ]]; then
    return 0
  fi
  local editor='/d/UE/UE_5.4/Engine/Binaries/Win64/UnrealEditor.exe'
  echo "Launching Project $1..."
  bash -c "${editor} \"${proj}\" &"
}

# Generated by Gemini 2.5-Pro
# This is the special function that Bash will call to get completion suggestions.
# The convention is to name it `_` followed by the command name.
_UEproj_completions() {
  # `cur` is a special variable holding the current word being completed.
  local cur
  cur="${COMP_WORDS[COMP_CWORD]}"

  # `COMPREPLY` is an array variable that we fill with our suggestions.
  # `compgen` is a Bash built-in that generates completion matches.
  #
  # -W "${opts}" : Provide a list of words to complete from.
  # -- "${cur}"  : The word that is currently being typed.
  #
  # The `opts` variable is populated by finding all subdirectories (`-type d`)
  # directly inside `PROJECTS_DIR` and printing just their base names (`-printf "%f\n"`).

  local opts
  opts=$(find "$UEProjBashPath" -maxdepth 1 -mindepth 1 -type d -printf "%f\n")

  COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
}
# --- REGISTRATION ---
# This command registers the `_goproj_completions` function to be called
# whenever completion is requested for the `goproj` command.
complete -F _UEproj_completions UEClang UEBuild

# Integrate fzf into bash
eval "$(fzf --bash)"
