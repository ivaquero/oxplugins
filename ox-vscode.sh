#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

OX_ELEMENT[vs]=${APPDATA}/Code/User/settings.json
OX_ELEMENT[vsk]=${APPDATA}/Code/User/keybindings.json
OX_ELEMENT[vss_]=${APPDATA}/Code/User/snippets
# backup files
OX_OXIDE[bkvsk]=${OX_BACKUP}/vscode/keybindings.json
OX_OXIDE[bkvss_]=${OX_BACKUP}/vscode/snippets
OX_OXIDE[bkvsx]=${OX_BACKUP}/vscode/vscode-exts.txt

##########################################################
# Cache
##########################################################

if [[ $(uname) = "Darwin" ]]; then
    vscl() {
        printf "Cleaning up VSCode Cache.\n"
        rm -rfv "${APPDATA}"/Code/Cache/*

        case "$1" in
        -a)
            printf "Cleaning up VSCode Workspace Storage.\n"
            rm -rfv "${APPDATA}"/Code/User/workspaceStorage/*
            ;;
        esac
    }
fi

##########################################################
# extensions
##########################################################

alias vsis="code --install-extension"
alias vsus="code --uninstall-extension"
alias vsls="code --list-extensions"

##########################################################
# integration
##########################################################

# shell
if [[ ${TERM_PROGRAM} == "vscode" ]]; then
    case ${SHELL} in
    *zsh)
        eval "$(code --locate-shell-integration-path zsh)"
        ;;
    *bash)
        eval "$(code --locate-shell-integration-path bash)"
        ;;
    esac
fi
