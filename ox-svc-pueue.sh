#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# system files
if [[ $(uname) = "Darwin" ]]; then
    OX_ELEMENT[pu]=${HOME}/Library/Preferences/pueue/pueue.yml
    OX_ELEMENT[pua]=${HOME}/Library/Preferences/pueue/pueue_aliases.yml
else
    OX_ELEMENT[pu]=${HOME}/.config/pueue/pueue.yml
    OX_ELEMENT[pua]=${HOME}/.config/pueue/pueue_aliases.yml
fi

# backup files
OX_OXIDE[bkpu]=${OX_BACKUP}/pueue/pueue.yml
OX_OXIDE[bkpua]=${OX_BACKUP}/pueue/pueue_aliases.yml

##########################################################
# management
##########################################################

alias pus="pueue start"
alias purs="pueue restart"
alias pua="pueue add"
alias purm="pueue remove"
alias pupa="pueue pause"
alias pucl="pueue clean && pueue status"
alias pust="pueue status"
alias puq="pueue kill"

##########################################################
# main
##########################################################

alias puh="pueue help"
alias pued="pueue edit"
alias purt="pueue reset"

##########################################################
# brew related
##########################################################

brew_upgrade_parallel() {
    local num=$1
    local pkgs=$2

    if [[ $num == 0 ]]; then
        echo "No outdated packages"
    elif [[ $num == 1 ]]; then
        brew upgrade "$pkgs"
    else
        echo "Trying to update $num pkgs in parallel"
        pueue group add brew_upgrade
        pueue parallel "$num" -g brew_upgrade

        echo "$pkgs" | while read -r line; do
            echo "upgrade $line"
            pueue add -g brew_upgrade "brew upgrade $line --no-quarantine"
        done

        pueue wait -g brew_upgrade
        pueue status
    fi
}

bupp() {
    case "$1" in
    -g)
        pkgs=$(brew outdated --greedy-auto-updates)
        num=$(echo "$pkgs" | wc -l | tr -d ' ')

        brew_upgrade_parallel "$num" "$pkgs"
        ;;
    *)
        local n_args=$#
        if [[ $n_args -gt 1 ]]; then
            brew_upgrade_parallel $n_args "$@"
        else
            pkgs=$(brew outdated)
            num=$(echo "$pkgs" | wc -l | tr -d ' ')

            brew_upgrade_parallel "$num" "$pkgs"
        fi
        ;;
    esac
}

bisp() {
    local n_args=$#
    if [[ $n_args -gt 1 ]]; then
        echo "Trying to install $n_args pkgs in parallel"
        pueue group add brew_install
        pueue parallel $n_args -g brew_install

        for pkg in "$@"; do
            pueue add -g brew_install "brew install --cask $pkg --no-quarantine"
        done

        pueue wait -g brew_install
        pueue status
    else
        echo "It's needless to parallel when less then 2 packages "
    fi
}
