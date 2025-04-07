#!/bin/bash
##########################################################
# config
##########################################################

# system files
OX_ELEMENT[s]="$HOME/.config/scoop/config.json"

bks=$(echo "$OX_OXIDE" | jq -r .bks)
up_scoop() {
    echo "Update Scoop by $bks"
    scoop import "$bks"
}

back_scoop() {
    echo "Backup Scoop to $bks"
    scoop export >"$bks"
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
