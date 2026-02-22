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

alias nis="npm install"
alias nus="npm uninstall"
alias nup="npm update"
alias nst="npm outdated"
alias nsc="npm search"
alias ncl="npm pm cache clean -f"

##########################################################
# info
##########################################################

alias nh="npm help"
alias nif="npm info"
alias nls="npm list"
alias nlv="npm list --depth 0"
alias nck="npm doctor"

##########################################################
# project
##########################################################

alias ncf="npm config"
alias nii="npm init"
alias nr="npm run"
alias nts="npm test"
alias npb="npm publish"
nfx() {
    npm audit fix "$@"
    npm audit "$@"
}
