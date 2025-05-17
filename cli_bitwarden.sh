#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

up_bitwarden() {
    bw import "$@"
}

back_bitwarden() {
    bw export "$@"
}

alias bwcf="bw config"

##########################################################
# query
##########################################################

# $1=object
bwsc() {
    local option="$1"
    local target="$2"

    case "$option" in
    -h) bw get --help ;;
    -u) bw get username "$target" ;;
    -p) bw get password "$target" ;;
    -n) bw get notes "$target" ;;
    -i) bw get item "$target" --pretty ;;
    *)
        echo "Usage: bwsc OPTION TARGET
Options:
  -h      Show help message.
  -u      Get username.
  -p      Get password.
  -n      Get notes.
  Otherwise, get the specified item with pretty print."
        ;;
    esac
}

alias bwst="bw status --pretty"
alias bwh="bw --help"

##########################################################
# project management
##########################################################

alias bwup="bw sync"

##########################################################
# item management
##########################################################

# $1=object
bwed() {
    local option="$1"
    local target="$2"

    case "$option" in
    -d) bw edit folder "$target" ;;
    -i) bw edit item "$target" ;;
    *) echo "Usage: bwed OPTION TARGET
Options:
  -d      Edit folder.
  -i      Edit item." ;;
    esac
}

# $1=object
bwrm() {
    local option="$1"
    local target="$2"

    case "$option" in
    -d) bw delete folder "$target" ;;
    -i) bw delete item "$target" ;;
    *) echo "Usage: bwrm OPTION TARGET
Options:
  -d      Delete folder.
  -i      Delete item." ;;
    esac
}

alias bwa="bw create"
alias bwls="bw list"
