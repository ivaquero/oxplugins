#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

if command -v pixi >/dev/null 2>&1; then
    case ${SHELL} in
    *zsh)
        eval "$(pixi completion --shell zsh)"
        ;;
    *bash)
        eval "$(pixi completion --shell bash)"
        ;;
    esac
fi

##########################################################
# packages
##########################################################

alias pxh="pixi --help"
alias pxcf="pixi config"
alias pxi="pixi install"
alias pxis="pixi install"
alias pxus="pixi uninstall"
alias pxup="pixi update"

##########################################################
# info
##########################################################

alias pxsc="pixi search"
alias pxls="pixi list"
alias pxlv="pixi tree | sort"

##########################################################
# project
##########################################################

alias pxii="pixi init"
alias pxr="pixi run"
