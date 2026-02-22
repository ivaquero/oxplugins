#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# system files
OX_ELEMENT[nj]=${HOME}/.npmrc
# backup files
export NODE_EXTRA_CA_CERTS="${HOMEBREW_PREFIX}/share/ca-certificates/cacert.pem"

bknode=$(echo "$OX_OXIDE" | jq -r .bknjx)
up_node() {
    echo "Update Node by $bknode"
    pkgs=$(tr "\n" " " <"$bknode")
    echo "Installing $pkgs"
    eval "npm install -g $pkgs --force"
}

back_node() {
    echo "Backup Node to $bknode"
    npm list -g | rg -o '\w+@' | tr -d '@' >"$bknode"
}

##########################################################
# packages
##########################################################

nis() {
    npm install "$@"
}
nus() {
    case npm in
    pnpm) pnpm remove "$@" ;;
    npm) npm uninstall "$@" ;;
    esac
}
nup() {
    npm update "$@"
}
nst() {
    npm outdated "$@"
}
nsc() {
    npm search "$@"
}
ncl() {
    case npm in
    pnpm) pnpm cache delete "$@" ;;
    npm) npm cache clean -f ;;
    esac
}

##########################################################
# info
##########################################################

nh() {
    npm help "$@"
}
nif() {
    npm info "$@"
}
nls() {
    npm list "$@"
}
nlv() {
    npm list --depth 0
}
nck() {
    npm doctor
}

##########################################################
# project
##########################################################

ncf() {
    npm config "$@"
}
nii() {
    npm init "$@"
}
nr() {
    npm run "$@"
}
nts() {
    npm test "$@"
}
npb() {
    npm publish "$@"
}
nfx() {
    npm audit fix --force "$@"
    npm audit "$@"
}
