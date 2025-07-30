#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# system files
OX_ELEMENT[nj]=${HOME}/.npmrc
# backup files
export NODE_EXTRA_CA_CERTS="${HOMEBREW_PREFIX}/share/ca-certificates/cacert.pem"

if command -v pnpm >/dev/null 2>&1; then
    export OX_NPM="pnpm"
elif command -v npm >/dev/null 2>&1; then
    export OX_NPM="npm"
else
    echo "No nodejs package manager found"
fi

bknode=$(echo "$OX_OXIDE" | jq -r .node)
up_node() {
    echo "Update Node by $bknode"
    pkgs=$(tr "\n" " " <"$bknode")
    echo "Installing $pkgs"
    eval "$OX_NPM install -g $pkgs --force"
}

back_node() {
    echo "Backup Node to $bknode"
    $OX_NPM list -g | rg -o '\w+@' | tr -d '@' >"$bknode"
}

##########################################################
# packages
##########################################################

nis() {
    $OX_NPM install "$@"
}
nus() {
    case $OX_NPM in
    pnpm) pnpm remove "$@" ;;
    npm) npm uninstall "$@" ;;
    esac
}
nup() {
    $OX_NPM update "$@"
}
nst() {
    $OX_NPM outdated "$@"
}
nsc() {
    $OX_NPM search "$@"
}
ncl() {
    case $OX_NPM in
    pnpm) pnpm cache delete "$@" ;;
    npm) npm cache clean -f ;;
    esac
}

##########################################################
# info
##########################################################

nh() {
    $OX_NPM help "$@"
}
nif() {
    npm info "$@"
}
nls() {
    $OX_NPM list "$@"
}
nlv() {
    $OX_NPM list --depth 0
}
nck() {
    $OX_NPM doctor
}

##########################################################
# project
##########################################################

ncf() {
    $OX_NPM config "$@"
}
nii() {
    $OX_NPM init "$@"
}
nr() {
    $OX_NPM run "$@"
}
nts() {
    $OX_NPM test "$@"
}
npb() {
    $OX_NPM publish "$@"
}
nfx() {
    $OX_NPM audit fix --force "$@"
    $OX_NPM audit "$@"
}
