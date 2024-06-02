#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# system files
OX_ELEMENT[nj]=${HOME}/.npmrc
# backup files
if [[ ! -d "${OX_BACKUP}"/javascript ]]; then
    mkdir -p -v "${OX_BACKUP}"/javascript
fi
OX_OXIDE[bkn]=${OX_BACKUP}/javascript/.npmrc
OX_OXIDE[bkjsx]=${OX_BACKUP}/javascript/js-pkgs.txt

export NODE_EXTRA_CA_CERTS="${HOMEBREW_PREFIX}/share/ca-certificates/cacert.pem"

up_node() {
    echo "Update Node by ${OX_OXIDE[bknjx]}"
    pkgs=$(tr "\n" " " <"${OX_OXIDE[bknjx]}")
    echo "Installing $pkgs"
    eval "npm install -g $pkgs --force"
}

back_node() {
    echo "Backup Node to ${OX_OXIDE[bknjx]}"
    npm list -g | rg -o '\w+@' | tr -d '@' >"${OX_OXIDE[bknjx]}"
}

##########################################################
# packages
##########################################################

alias nis="npm install"
alias nus="npm uninstall"
alias nisg="npm install -g"
alias nusg="npm uninstall -g"
alias nup="npm update"
alias nupg="npm update -g"
alias nst="npm outdated"
alias nsc="npm search"
alias ncl="npm cache clean -f"

##########################################################
# info
##########################################################

alias nh="npm help"
alias nif="npm info"
alias nls="npm list"
alias nlsg="npm list -g"
alias nlv="npm list --depth 0"
alias nlvg="npm list --depth 0 -g"
alias nck="npm doctor"

##########################################################
# project
##########################################################

alias ncf="npm config"
alias nii="npm init"
alias nr="npm run"
alias nts="npm test"
alias nau="npm audit"
alias nfx="npm audit fix"
alias npb="npm publish"

##########################################################
# packages
##########################################################

alias yis="yarn add"
alias yisg="yarn global add"
alias yus="yarn remove"
alias yusg="yarn global remove"
alias yup="yarn upgrade"
alias yupg="yarn global upgrade"
alias yst="yarn outdated"

##########################################################
# packages
##########################################################

alias yls="yarn list"
alias ylsg="yarn global list"
alias yif="yarn info"

##########################################################
# project
##########################################################

alias ycf="yarn config"
alias yii="yarn init"
alias yr="yarn run"
alias yau="yarn audit"
alias ypb="yarn publish"
