#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# system files

case $(uname -a) in
*Darwin* | *Ubuntu* | *Debian* | *WSL*)
    export ESPANSO_DATA="${APPDATA}/espanso"
    ;;
*MINGW*)
    if [[ -f "$SCOOP/shims/espansod" ]]; then
        export ESPANSO_DATA="$SCOOP/persist/espanso/.espanso"
    fi
    ;;
esac

# system files
OX_ELEMENT[es]=${ESPANSO_DATA}/config/default.yml
OX_ELEMENT[esb]=${ESPANSO_DATA}/match/base.yml
OX_ELEMENT[esx_]=${ESPANSO_DATA}/match/packages
# backup files
OX_OXIDE[bkes]=${OX_BACKUP}/espanso/config/default.yml
OX_OXIDE[bkesb]=${OX_BACKUP}/espanso/match/base.yml
OX_OXIDE[bkesx_]=${OX_BACKUP}/espanso/match/packages

##########################################################
# packages
##########################################################

alias esis="espanso package install"
alias esus="espanso package uninstall"
alias esls="espanso package list"

esup() {
    if [[ -z "$1" ]]; then
        pkgs=$(espanso package list | rg -o "\w+.*\s-" | rg -o ".+*\w")
        echo "$pkgs" | while read -r line; do
            espanso package update "$line"
        done
    else
        espanso package update "$1"
    fi
}

##########################################################
# management
##########################################################

alias ess="espanso start"
alias esrs="espanso restart"
alias esst="espanso status"
alias esq="espanso stop"

##########################################################
# main
##########################################################

esa() {
    touch "${APPDATA}"/espanso/match/"$1".yml
}

alias esh="espanso help"
alias esed="espanso edit"
