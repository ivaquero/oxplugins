#!/bin/bash
##########################################################
# config
##########################################################

# system files
OX_ELEMENT[w]="$HOME/AppData/Local/Packages/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe/LocalState/settings.json"
# backup files
OX_OXIDE[bks]="$OX_BACKUP/win/scoop.jsonc"
OX_OXIDE[bksx]="$OX_BACKUP/win/Scoopfile.json"

up_scoop() {
    echo "Update Scoop by ${OX_OXIDE[bksx]}"
    scoop import "${OX_OXIDE[bks]}"
}

back_scoop() {
    echo "Backup Scoop to ${OX_OXIDE[bksx]}"
    scoop export >"${OX_OXIDE[bks]}"
}

##########################################################
# packages
##########################################################

alias sis="scoop install"
alias sus="scoop uninstall"

sris() {
    scoop uninstall "$@"
    scoop install "$@"
}

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
        scoop cleanup --all
        rm -r "$SCOOP"/cache
    else
        scoop cleanup "$@"
    fi
}

alias sdp="scoop depends"
alias sck="scoop checkup"
alias ssc="scoop search"

# info & version
alias sif="scoop info"
alias sst="scoop status"
alias spn="scoop hold"
alias spnr="scoop unhold"

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
