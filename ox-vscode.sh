#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

export VSCODE_DATA="${APPDATA}/Code"

if [[ $(uname) = "*MINGW*" ]]; then
    if [[ ! -d ${VSCODE_DATA} ]]; then
        export VSCODE_DATA="$SCOOP\persist\vscode\data\user-data"
    fi
fi

OX_ELEMENT[vs]=${VSCODE_DATA}/User/settings.json
OX_ELEMENT[vsk]=${VSCODE_DATA}/User/keybindings.json
OX_ELEMENT[vss_]=${VSCODE_DATA}/User/snippets
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
        rm -rfv "${VSCODE_DATA}"/Cache/*

        case "$1" in
        -a)
            printf "Cleaning up VSCode Workspace Storage.\n"
            rm -rfv "${VSCODE_DATA}"/User/workspaceStorage/*
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
