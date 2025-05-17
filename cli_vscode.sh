#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

export VSCODE_DATA="${APPDATA}/Code"

OX_ELEMENT[vs]=${VSCODE_DATA}/User/settings.json
OX_ELEMENT[vsk]=${VSCODE_DATA}/User/keybindings.json
OX_ELEMENT[vss_]=${VSCODE_DATA}/User/snippets

back_vscode() {
    # shellcheck disable=SC2155
    local bkvs=$(echo "$OX_OXIDE" | jq -r .bkvsx)
    echo "Backup VSCode extensions to ${OX_BACKUP}/$bkvs"
    code --list-extensions >"${OX_BACKUP}/$bkvs"
}

##########################################################
# Cache
##########################################################

vscl() {
    printf "Cleaning up VSCode Cache.\n"
    rm -rfv "${VSCODE_DATA}"/Cache/*
    printf "Cleaning up VSCode Obselete History.\n"
    rm -rfv "${VSCODE_DATA}"/User/History/-*
    printf "Cleaning up VSCode Obselete Profiles.\n"
    rm -rfv "${VSCODE_DATA}"/User/profiles/-*

    local option="$1"
    case "$option" in
    -a)
        printf "Cleaning up VSCode Workspace Storage.\n"
        rm -rfv "${VSCODE_DATA}"/User/workspaceStorage/*
        ;;
    *)
        echo "Usage: vscl OPTION
Options:
  -a      Clean up VSCode Workspace Storage."
        ;;
    esac
}

##########################################################
# extensions
##########################################################

alias vsis="code --install-extension"
alias vsus="code --uninstall-extension"
alias vsls="code --list-extensions"
