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
