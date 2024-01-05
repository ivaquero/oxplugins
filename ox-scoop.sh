#!/bin/bash
##########################################################
# config
##########################################################

# default files
OX_OXYGEN[oxs]="$OXIDIZER/defaults/Scoopfile.txt"
# backup files
if [[ ! -d "${OX_BACKUP}"/install ]]; then
    mkdir -p "$OX_BACKUP/install"
fi
OX_OXIDE[bks]="$OXIDIZER/defaults/Scoopfile.txt"

up_scoop() {
    echo "Update Scoop by ${OX_OXIDE[bks]}"
    scoop import $"{OX_OXIDE[bks]}"
}

back_scoop() {
    echo "Backup Scoop to ${OX_OXIDE[bks]}"
    scoop export >"${OX_OXIDE[bks]}"
}

##########################################################
# packages
##########################################################

alias sis="scoop install"
alias sus="scoop uninstall"
alias sls="scoop list"
alias sups="scoop update"

sup() {
    if [[ -z "$1" ]]; then
        scoop update --all
    else
        scoop update "$@"
    fi
}

scl() {
    if [[ -z "$1" ]]; then
        scoop cleanup --all --cache
    else
        scoop cleanup "$@" --cache
    fi
}

alias sdp="scoop depends"
alias sck="scoop checkup"
alias ssc="scoop search"

# info & version
alias sif="scoop info"
alias sst="scoop status"
alias spn="scoop hold"
alias supn="scoop unhold"

# aria2
alias sat="scoop config aria2-enabled true"
alias saf="scoop config aria2-enabled false"

##########################################################
# extension
##########################################################

alias sxa="scoop bucket add"
alias sxrm="scoop bucket rm"
alias sxls="scoop bucket list"

##########################################################
# project
##########################################################

alias sii="scoop create"
alias sca="scoop cat"
