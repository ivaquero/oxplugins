#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# backup files
if [[ ! -d "${OX_BACKUP}"/text ]]; then
    mkdir -p -v "${OX_BACKUP}"/text
fi
OX_OXIDE[bktl]=${OX_BACKUP}/text/texlive-pkgs.txt

if [[ $(uname) = "Darwin" ]]; then
    export texlive=/usr/local/texlive
fi

# bin
eval "$(/usr/libexec/path_helper)"

up_texlive() {
    echo "Update TeXLive by ${OX_OXIDE[bktl]}"

    while read -r line <"${OX_OXIDE[bktl]}"; do
        echo "Installing $line"
        tlmgr install "$line"
    done
}

back_texlive() {
    echo "Backup TeXLive to ${OX_OXIDE[bktl]}"
    tlmgr list --only-installed | rg -o "collection-\w+" | rg -v "basic" >"${OX_OXIDE[bktl]}"
}

##########################################################
# packages
##########################################################

alias tlup="sudo tlmgr update --all"
alias tlups="sudo tlmgr update --all --self"
alias tlck="sudo tlmgr check"
alias tlis="sudo tlmgr install"
alias tlus="sudo tlmgr remove && tlmgr check"

##########################################################
# info
##########################################################

alias tllsa="tlmgr list"
alias tlls="tlmgr list --only-installed"
alias tlif="tlmgr info"
alias tlifc="tlmgr info collections"
alias tlifs="tlmgr info schemes"
alias tlh="tlmgr -h"
