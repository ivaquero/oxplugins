#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

if [[ $(arch) = "arm64" ]]; then
    export TERMINFO=/usr/share/terminfo
else
    export TERMINFO=/usr/local/share/terminfo
fi

##########################################################
# main
##########################################################

export CACHES=${HOME}/Library/Caches
export APPDATA="${HOME}/Library/Application Support"

update() {
    printf "Installing needed updates.\n"
    softwareupdate -i -a >/dev/null 2>&1
}

alias allowx="xattr -r -d com.apple.quarantine"
allow() {
    sudo spctl --master-disable
    printf "Initial letter needs to be capitalized\n"

    for app in /Applications/"$1"*.app; do
        if [[ -z $app ]]; then
            echo "$app not found."
        else
            echo "Cracking $app"
            allowx "$app"
            codesign --force --deep --sign - "$app"
        fi
    done
}

##########################################################
# computer
##########################################################

shutdown() {
    if [[ -z "$1" ]]; then
        echo "Shutting down."
        eval "sudo shutdown -h now"
    else
        echo "Shutting down in $1 seconds."
        eval "sudo shutdown -h $1"
    fi
}

restart() {
    if [[ -z "$1" ]]; then
        echo "Restarting."
        eval "sudo shutdown -r now"
    else
        echo "Restarting in $1 seconds."
        eval "sudo shutdown -r +$1"
    fi
}

hibernate() {
    echo "Hibernating."
    shutdown -s now
}

sysinfo() {
    sysctl -a | rg "$1"
}

##########################################################
# time machine
##########################################################

alias tmh="tmutil -h"
alias tms="tmutil startbackup"
alias tmq="tmutil stopbackup"
alias tmls="tmutil listbackups"
alias tmrm="tmutil delete"

##########################################################
# mas - app store
##########################################################

if command -v mas >/dev/null 2>&1; then
    alias mis="mas install"
    alias mus="sudo mas uninstall"
    alias mup="mas upgrade"
    alias mcf="mas config"
    alias mif="mas info"
    alias mls="mas list"
    alias mst="mas outdated"
    alias msc="mas search"
fi
