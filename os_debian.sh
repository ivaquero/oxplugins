#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# system files
OX_ELEMENT[scls]="/etc/apt/sources.list"

# shortcuts
if command -v xdg-open >/dev/null 2>&1; then
    alias open="xdg-open"
elif command -v nautilus >/dev/null 2>&1; then
    alias open="nautilus"
fi

##########################################################
# main
##########################################################

update() {
    case "$1" in
    -d) sudo apt dselect-upgrade ;;
    *) sudo apt dist-upgrade ;;
    esac
}

clean() {
    case "$1" in
    cc)
        sudo rm -rfv /var/cache
        ;;
    zs)
        rm "${HOME}"/.zsh_sessions/*.history*
        rm "${HOME}"/.zsh_sessions/*_timestamp
        ;;
    log)
        printf "Emptying the system log files.\n"
        sudo rm -rfv /var/log/*
        ;;
    *)
        printf "Emptying trash.\n"
        rm -rfv "${HOME}"/.local/share/Trash >/dev/null 2>&1
        ;;
    esac
}

sysinfo() {
    sysctl -a | rg "$1"
}

##########################################################
# apt
##########################################################

alias ah="apt help"
alias asc="apt-cache search"
alias aif="apt-cache show"
alias adp="apt-cache depends"
alias adpr="apt-cache rdepends"
alias als="apt list --installed"

alias ais="sudo apt install"
alias aus="sudo apt remove"
alias ausp="sudo apt remove --purge"
alias aups="sudo apt update"
alias aup="sudo apt upgrade"
alias acl="sudo apt autoremove && sudo apt clean && sudo apt autoclean"
alias aclp="sudo apt autoremove --purge && sudo apt clean && sudo apt autoclean"
alias ack="sudo apt check"

###########################################################
# apt extension
##########################################################

alias axa="sudo add-apt-repository"
alias axrm="sudo add-apt-repository --remove"
alias axls="rg ^[^#] /etc/apt/sources.list"
