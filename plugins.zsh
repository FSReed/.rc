#!/usr/bin/bash

# Get Zsh Plugins

plugins=(
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-autosuggestions"
    "MichaelAquilina/zsh-you-should-use"
)

ZSH_CUSTOM_PLUGIN=${HOME}/.oh-my-zsh/custom/plugins

for item in ${plugins[@]}; do
    name=$(echo ${item} | cut -d/ -f2)

    if ! [[ -d ${ZSH_CUSTOM_PLUGIN}/${name} ]]; then
        git clone https://github.com/${item}.git ${ZSH_CUSTOM_PLUGIN}/${name}
    fi
done

