#!/bin/bash /bin/zsh
##########################################################
# Configuration File Utils
##########################################################

test_oxpath() {
    if [[ -z "$1" ]]; then
        echo "$1 does not exist, please define it in custom.sh"
    fi

    if [[ ! -d "$(dirname "$1")" ]]; then
        mkdir -p -v "$(dirname "$1")"
    fi
}

# oxidize file: backup configuration file to personalized folder
oxf() {
    for file in "$@"; do
        local in_path=${OX_ELEMENT[$file]}
        # shellcheck disable=SC2155
        local out_path="$OX_BACKUP"/$(echo "$OX_OXIDE" | jq -r ."bk$file")

        test_oxpath "$out_path"

        if [[ $file == *_ ]]; then
            rm -rf "$out_path"
            cp -R -v "$in_path" "$out_path"
        else
            cp -v "$in_path" "$out_path"
        fi

    done
}

# reduce file: overwrite configuration file by personalized file
rdf() {
    for file in "$@"; do
        # shellcheck disable=SC2155
        local in_path="$OX_BACKUP"/$(echo "$OX_OXIDE" | jq -r ."bk$file")
        local out_path=${OX_ELEMENT[$file]}

        test_oxpath "$out_path"

        if [[ $file == *_ ]]; then
            rm -rf "$out_path"
            cp -R -v "$in_path" "$out_path"
        else
            cp -v "$in_path" "$out_path"
        fi
    done
}

# catalyze file: overwrite configuration file by OXIDIZER defaults
clzf() {
    for file in "$@"; do
        # shellcheck disable=SC2155
        local in_path="$OXIDIZER"/$(echo "$OX_OXYGEN" | jq -r ."ox$file")
        local out_path=${OX_ELEMENT[$file]}

        test_oxpath "$out_path"
        cp -v "$in_path" "$out_path"
    done
}

# propagate file: backup OXIDIZER defaults to backup folder
ppgf() {
    for file in "$@"; do
        # shellcheck disable=SC2155
        local in_path="$OXIDIZER"/$(echo "$OX_OXYGEN" | jq -r ."ox$file")
        # shellcheck disable=SC2155
        local out_path="$OX_BACKUP"/$(echo "$OX_OXIDE" | jq -r ."bk$file")

        test_oxpath "$out_path"
        cp -v "$in_path" "$out_path"
    done
}

##########################################################
# General File Utils
##########################################################

# refresh file
rff() {
    if [[ -z "$1" ]]; then
        . "${OX_ELEMENT[zs]}"
    else
        . "${OX_ELEMENT[$1]}"
    fi
}

# browse file
# $1=name
brf() {
    if [[ "$1" == *_ ]]; then
        cmd="ls"
    else
        cmd="cat"
    fi
    case "$1" in
    bk[a-z]*) $cmd "$OX_BACKUP"/"$(echo "$OX_OXIDE" | jq -r ."$1")" ;;
    ox[a-z]*) $cmd "$OXIDIZER"/"$(echo "$OX_OXYGEN" | jq -r ."$1")" ;;
    *) $cmd "${OX_ELEMENT[$1]}" ;;
    esac
}

# edit file by default editor
edf() {
    if [[ "$2" == -t ]]; then
        cmd=$EDITOR_T
    else
        cmd=$EDITOR
    fi
    case "$1" in
    bk[a-z]*) $cmd "$OX_BACKUP"/"$(echo "$OX_OXIDE" | jq -r ."$1")" ;;
    ox[a-z]*) $cmd "$OXIDIZER"/"$(echo "$OX_OXYGEN" | jq -r ."$1")" ;;
    *) $cmd "${OX_ELEMENT[$1]}" ;;
    esac
}

##########################################################
# Zip Files
##########################################################

alias zpf="ouch compress"
alias zpfr="ouch decompress"
alias zpfls="ouch list"

##########################################################
# Hash Files
##########################################################

if command -v hashsum >/dev/null 2>&1; then
    alias sha1="hashsum --sha1"
    alias sha2="hashsum --sha256"
    alias sha5="hashsum --sha512"
elif [[ $(uname -s) = "Darwin" ]]; then
    alias md5="hashsum --md5"
    alias sha1="shasum -a 1"
    alias sha2="shasum -a 256"
    alias sha5="shasum -a 512"
else
    alias md5="md5sum"
    alias sha1="sha1sum"
    alias sha2="sha256sum"
    alias sha5="sha512sum"
fi
