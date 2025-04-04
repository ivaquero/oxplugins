#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

case $(uname -a) in
*Darwin* | *Ubuntu* | *Debian* | *WSL*)
    export VSCODE_DATA="${APPDATA}/Code"
    ;;
*MINGW*)
    if [[ -f "$SCOOP/app/current/vscode/bin/code" ]]; then
        export VSCODE_DATA="$SCOOP/persist/vscode/data/user-data"
    fi
    ;;
esac

OX_ELEMENT[vs]=${VSCODE_DATA}/User/settings.json
OX_ELEMENT[vsk]=${VSCODE_DATA}/User/keybindings.json
OX_ELEMENT[vss_]=${VSCODE_DATA}/User/snippets

back_vscode() {
    echo "Backup VSCode extensions to ${OX_OXIDE[bkvsx]}"
    code --list-extensions >"${OX_OXIDE[bkvsx]}"
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
