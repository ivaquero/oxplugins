#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# system files
OX_ELEMENT[cg]=${HOME}/.cargo/config.toml
OX_ELEMENT[rs]=${HOME}/.rustup/settings.toml

##########################################################
# packages
##########################################################

alias cgh="cargo help"
alias cgis="cargo install"
alias cgus="cargo uninstall"
alias cgup="cargo update"
alias cgls="cargo install --list"
alias cgcl="cargo clean"
alias cgsc="cargo search"
alias cgck="cargo check"
alias cgdp="cargo tree"
alias cgcf="cargo config"

cgif() {
    if [[ -z "$1" ]]; then
        cargo info
    else
        cargo "$1" info
    fi
}

##########################################################
# project
##########################################################

alias cgb="cargo build"
alias cgr="cargo run"
alias cgts="cargo test"
alias cgfx="cargo fix"
alias cgpb="cargo publish"
alias cgii="cargo init"
alias cgcr="cargo new"

##########################################################
# rustup
##########################################################

alias rsh="rustup help"
alias rsis="rustup component add"
alias rsus="rustup component remove"
alias rsls="rustup component list"
alias rsup="rustup update"
alias rsck="rustup check"
alias rsr="rustup run"
