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

clean() {
    case "$1" in
    zsh)
        printf "Cleaning up ZSH History.\n"
        rm -rfv "${HOME}"/.zsh_sessions/*
        rm -fv "${HOME}"/.zsh_history
        ;;
    chrome)
        printf "Cleaning up Chrome Cache.\n"
        rm -rfv "${CACHES}"/Google/Chrome/*
        ;;
    container)
        printf "Cleaning Container Caches\n"
        for ct in ${HOME}/Library/Containers; do
            rm -rfv ~/Library/Containers/"$ct"/Data/Library/Caches/*
        done
        ;;
    volume)
        printf "Emptying trash in Volumes.\n"
        sudo rm -rfv /Volumes/*/.Trashes
        ;;
    log)
        printf "Emptying the system log files.\n"
        sudo log erase
        ;;
    *)
        printf "Emptying trash.\n"
        rm -rfv "${HOME}"/.Trash/*
        ;;
    esac
}

allow() {
    sudo spctl --master-disable
    printf "Initial letter needs to be capitalized\n"

    for app in /Applications/"$1"*.app; do
        if [[ -z $app ]]; then
            echo "$app not found."
        else
            echo "Cracking $app"
            xattr -r -d com.apple.quarantine "$app"
        fi
    done
}

sign() {
    printf "Initial letter needs to be capitalized\n"

    for app in /Applications/"$1"*.app; do
        if [[ -z $app ]]; then
            echo "$app not found."
        else
            codesign --force --deep --sign - "$app"
        fi
    done
}

hide() {
    chflags hidden "$1"
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
