#!/bin/bash /bin/zsh
##########################################################
# source
##########################################################

# source system-specific commands
if [[ $(uname) = "Darwin" ]]; then
    if [[ $(arch) = "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/Homebrew/bin/brew shellenv)"
    fi
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

case ${SHELL} in
*zsh)
    if type brew &>/dev/null; then
        FPATH=${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}
        autoload -Uz compinit && compinit
        compaudit | xargs chmod g-w
    fi
    # shellcheck disable=SC1091
    [ -d "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting" ] && . "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    # shellcheck disable=SC1091
    [ -d "${HOMEBREW_PREFIX}/share/zsh-autosuggestions" ] && . "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ;;
*bash)
    if [ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]; then
        # shellcheck disable=SC1091
        . "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [ -r "${COMPLETION}" ] && source "${COMPLETION}"
        done
    fi
    ;;
esac

##########################################################
# config
##########################################################

# backup files
if [[ ! -d "${OX_BACKUP}"/install ]]; then
    mkdir -p -v "${OX_BACKUP}"/install
fi
OX_OXIDE[bkb]="${OX_BACKUP}"/install/Brewfile

up_brew() {
    echo "Update Brew by ${OX_OXIDE[bkb]}"
    brew bundle --file "${OX_OXIDE[bkb]}"
}

back_brew() {
    echo "Backup Brew to ${OX_OXIDE[bkb]}"
    brew bundle dump --force
}

clean_brew() {
    echo "Clean Brew by ${HOMEBREW_BUNDLE_FILE}"
    brew bundle cleanup
}

##########################################################
# packages
##########################################################

alias bh="brew help"
alias bcf="brew config"
alias bis="brew install --no-quarantine"
alias bus="brew uninstall"
alias bris="brew reinstall --no-quarantine"
alias bups="brew update"

chck_cask() {
    brew list --cask | rg "$1"
}

bup() {
    # shellcheck disable=SC2005
    chck=$(echo "$(chck_cask "$1")")
    if [[ -z $chck ]]; then
        brew upgrade "$1"
    else
        brew upgrade --cask --no-quarantine "$1"
    fi
}

alias busg="bus --zap"
alias bupg="bup --greedy"

bcl() {
    case "$1" in
    -a) brew autoremove && brew cleanup -s --prune=all ;;
    *) brew autoremove && brew cleanup -s ;;
    esac
}

##########################################################
# info & version
##########################################################

alias bck="brew doctor"

alias bls="brew list"
alias blsf="brew list --formula"
alias blv="brew leaves"
alias bdp="brew deps --tree --formula --installed"

alias bsc="brew search"

alias bif="brew info"
alias bpn="brew pin"

bupn() {
    brew unpin "$1" && brew update
}

bst() {
    case "$1" in
    -g) brew outdated --greedy ;;
    *) brew outdated ;;
    esac
}

##########################################################
# project
##########################################################

alias bii="brew create"
alias bts="brew test"
alias bed="brew edit"
alias bca="brew cat"
alias bau="brew audit"
alias bfx="brew style --fix"
alias blc="brew livecheck"
alias bln="brew link"
alias buln="brew unlink"

##########################################################
# casks
##########################################################

alias bisc="bis --cask --no-quarantine"
alias blsc="bls --cask"
alias bifc="bif --cask"
alias bedc="be --cask"

##########################################################
# cask development
##########################################################

HOMEBREW_DOWNLOAD=$(brew --cache)/downloads
export HOMEBREW_DOWNLOAD
HOMEBREW_CASK_API=$(brew --cache)/api/cask.jws.json
export HOMEBREW_CASK_API
export HOMEBREW_TAPS=${HOMEBREW_PREFIX}/Library/Taps

# get cask url
burl() {
    cask=$(print "$(jq '.payload' <"$HOMEBREW_CASK_API")" | rg "/$1".rb | rg -o '\{.+*\}')
    vars=$(echo "$cask" | jq '.variations.arm64_ventura.url')
    if [[ $vars == null ]]; then
        url=$(echo "$cask" | jq '.url')
        echo "$url"
    else
        url=$(echo "$cask" | jq '.variations')
        echo "$vars"
    fi
}

# replace cache file by predownloaded file
brp() {
    f_pred=$(fd "$1" "${OX_DOWNLOAD}")
    if [[ ! -f $f_pred ]]; then
        echo "predownloaded file not found"
        return 1
    fi
    f_cache=$(fd "$1" "${HOMEBREW_DOWNLOAD}" | sd '.incomplete' '')
    mv -v "$f_pred" "$f_cache"
}

bprc() {
    # shellcheck disable=SC2005
    check=$(echo "$(blc --cask "$1")" | rg -o " .+*" | tr -d ": ")
    fromV=${check%==>*}
    toV=${check#*==>}
    if [[ "$toV" != "$fromV" ]]; then
        echo "Updating $1 from $fromV to $toV"
        brew bump-cask-pr "$1" --version "$toV"
    else
        echo "There is no new version of $1"
    fi
}

##########################################################
# extensions
##########################################################

# taps
alias bxa="brew tap"
alias bxrm="brew untap"

# bundle: backup files
export HOMEBREW_BUNDLE_FILE=${OX_OXIDE[bkb]}

##########################################################
# brew services
##########################################################

alias bs="brew services"
alias bsh="brew services --help"
alias bsr="brew services run"
alias bscl="brew services cleanup"
alias bsif="brew services info"
alias bsls="brew services list"

bss() {
    if [[ ${#1} -lt 4 ]]; then
        brew services start "${HOMEBREW_SERVICE[$1]}"
    else
        brew services start "$1"
    fi
}

bsq() {
    if [[ ${#1} -lt 4 ]]; then
        brew services stop "${HOMEBREW_SERVICE[$1]}"
    else
        brew services stop "$1"
    fi
}

bsrs() {
    if [[ ${#1} -lt 4 ]]; then
        brew services restart "${HOMEBREW_SERVICE[$1]}"
    else
        brew services restart "$1"
    fi
}
