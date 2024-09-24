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
alias nup="npm update"
alias nst="npm outdated"
alias nsc="npm search"
alias ncl="npm cache clean -f"

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
    npm audit fix --force "$@"
    npm audit "$@"
}

##########################################################
# packages
##########################################################

yis() {
    local option="$1"
    shift
    local pkgs=("$@")

    case "$option" in
    -g)
        yarn global add "${pkgs[@]}"
        ;;
    *)
        yarn add "$option" "${pkgs[@]}"
        ;;
    esac
}

yrm() {
    local option="$1"
    shift
    local pkgs=("$@")

    case "$option" in
    -g)
        yarn global remove "${pkgs[@]}"
        ;;
    *)
        yarn remove "$option" "${pkgs[@]}"
        ;;
    esac
}

yup() {
    local option="$1"
    shift
    local pkgs=("$@")

    case "$option" in
    -g)
        yarn global upgrade "${pkgs[@]}"
        ;;
    *)
        yarn upgrade "$option" "${pkgs[@]}"
        ;;
    esac
}

alias yst="yarn outdated"

##########################################################
# packages
##########################################################

yls() {
    local option="$1"

    case "$option" in
    -g)
        yarn global list
        ;;
    *)
        yarn list
        ;;
    esac
}

alias yif="yarn info"

##########################################################
# project
##########################################################

alias ycf="yarn config"
alias yii="yarn init"
alias yr="yarn run"
alias ypb="yarn publish"
