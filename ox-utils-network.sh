#!/bin/bash /bin/zsh
##########################################################
# Proxy Utils
##########################################################

# px=proxy
px() {
    if [[ ${#1} -lt 3 ]]; then
        local port=${OX_PROXY[$1]}
    else
        local port=$1
    fi
    echo "using port $port"
    export https_proxy=http://127.0.0.1:$port
    export http_proxy=http://127.0.0.1:$port
    export all_proxy=socks5://127.0.0.1:$port
}

pxq() {
    echo 'unset all proxies'
    unset https_proxy
    unset http_proxy
    unset all_proxy
}

##########################################################
# wsl
##########################################################

# host list
host_ls() {
    rg "nameserver" </etc/resolv.conf | cut -f 2 -d " "
}

# host proxy
host_px() {
    export ALL_PROXY="https://$1:${OX_PROXY[$2]}"
}

##########################################################
# mirrors
##########################################################

mrb() {
    export HOMEBREW_BREW_GIT_REMOTE="https://${OX_MIRRORS[$1]}/brew.git"
    export HOMEBREW_CORE_GIT_REMOTE="https://${OX_MIRRORS[$1]}/homebrew-core.git"

    for tap in core bottles services cask{,-fonts} command-not-found; do
        brew tap --custom-remote --force-auto-update "homebrew/${tap}" "https://${OX_MIRRORS[b$1]}/homebrew-${tap}.git"
    done
    brew update
}

mrbq() {
    unset HOMEBREW_BREW_GIT_REMOTE
    git -C "$(brew --repo)" remote set-url origin https://github.com/Brew/brew
    unset HOMEBREW_CORE_GIT_REMOTE
    BREW_TAPS="$(
        BREW_TAPS="$(brew tap 2>/dev/null)"
        echo -n "${BREW_TAPS//$'\n'/:}"
    )"
    for tap in core bottles services cask{,-fonts} command-not-found; do
        if [[ ":${BREW_TAPS}:" == *":homebrew/${tap}:"* ]]; then
            brew tap --custom-remote "homebrew/${tap}" "https://github.com/Brew/homebrew-${tap}"
        fi
    done
    brew update
}
