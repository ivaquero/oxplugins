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
        local out_path=${OX_OXIDE[bk$file]}

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
        local in_path=${OX_OXIDE[bk$file]}
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

# catalyze file: overwrite configuration file by Oxidizer defaults
clzf() {
    for file in "$@"; do
        local in_path=${OX_OXYGEN[ox$file]}
        local out_path=${OX_ELEMENT[$file]}

        test_oxpath "$out_path"
        cp -v "$in_path" "$out_path"
    done
}

# propagate file: backup Oxidizer defaults to backup folder
ppgf() {
    for file in "$@"; do
        local in_path=${OX_OXYGEN[ox$file]}
        local out_path=${OX_OXIDE[bk$file]}

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
    ox[a-z]*) $cmd "${OX_OXYGEN[$1]}" ;;
    bk[a-z]*) $cmd "${OX_OXIDE[$1]}" ;;
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
    ox[a-z]*) $cmd "${OX_OXYGEN[$1]}" ;;
    bk[a-z]*) $cmd "${OX_OXIDE[$1]}" ;;
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

if test "$(command -v hashsum)"; then
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

##########################################################
# Editor
##########################################################

ched() {
    sed -i.bak "s|EDITOR=.*|EDITOR=\'$1\'|" "${OX_ELEMENT[ox]}"
    case ${SHELL} in
    *zsh)
        . "${OX_ELEMENT[zs]}"
        ;;
    *bash)
        . "${OX_ELEMENT[bs]}"
        ;;
    esac
}

##########################################################
# Zoxide
##########################################################

export _ZO_DATA_DIR=${HOME}/.config/zoxide

if [[ ! -d "$_ZO_DATA_DIR" ]]; then
    mkdir -p -v "$_ZO_DATA_DIR"
fi

OX_ELEMENT[z]=${_ZO_DATA_DIR}/db.zo

case ${SHELL} in
*zsh)
    eval "$(zoxide init zsh)"
    ;;
*bash)
    eval "$(zoxide init bash)"
    ;;
esac

alias zh="zoxide --help"
alias zii="zoxide init"
alias za="zoxide add"
alias zrm="zoxide remove"
alias zed="zoxide edit"
alias zsc="zoxide query"
