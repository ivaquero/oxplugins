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

# shellcheck disable=SC1090
# shellcheck disable=SC1091
case ${SHELL} in
*zsh)
    if type brew &>/dev/null; then
        FPATH=${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}
    fi
    [ -d "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting" ] && . "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    [ -d "${HOMEBREW_PREFIX}/share/zsh-autosuggestions" ] && . "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ;;
*bash)
    if [ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]; then
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

bus() {
    local flags="-v"
    while getopts "g:" opt; do
        case "$opt" in
        g)
            flags="$flags --zap"
            shift
            ;;
        *)
            flags="$flags -$OPTARG"
            shift
            ;;
        esac
    done
    local pkgs=("$@")

    brew uninstall "$flags" "$pkg"
}

alias bris="brew reinstall --no-quarantine"
alias bups="brew update"

is_cask() {
    brew list --cask | rg "$1"
}

is_pinned() {
    brew outdated --formula "$1" | rg 'pinned'
}

# shellcheck disable=SC2005
bup() {
    if [[ -z $1 ]]; then
        brew upgrade
    else
        local flags="-v"
        while getopts "*:" opt; do
            case "$opt" in
            *)
                flags="$flags -$OPTARG"
                shift
                ;;
            esac
        done

        local pkgs=("$@")
        for pkg in "${pkgs[@]}"; do
            cask=$(is_cask "$pkg")
            if [[ $cask -eq "" ]]; then
                echo "$pkg is a Formula"
                pinned=$(is_pinned "$pkg")
                if [[ $pinned -ne "" ]]; then
                    echo "unpin $pkg"
                    brew unpin "$pkg"
                fi
                brew upgrade "$flags" "$pkg"
            else
                brew upgrade "$flags" --cask --no-quarantine "$pkg"
            fi
        done

    fi
}

bcl() {
    local option="$1"

    case "$option" in
    -g)
        echo "Executing greedy cleanup..."
        brew autoremove || exit 1
        brew cleanup -s --prune=all || exit 1
        ;;
    *)
        echo "Executing standard cleanup..."
        brew autoremove || exit 1
        brew cleanup -s || exit 1
        ;;
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
alias bpnr="brew unpin"

bst() {
    local option="$1"

    case "$option" in
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
alias blnr="brew unlink"

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

# shellcheck disable=SC2005
bprc() {
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
