#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

alias open="explorer"
export APPDATA="${HOME}/AppData"

##########################################################
# computer
##########################################################

alias shutdown="shutdown.exe -s"
alias restart="shutdown.exe -r"

hibernate() {
    echo "Hibernating."
    shutdown -h
}

##########################################################
# winget
##########################################################

# system files
OX_ELEMENT[s]="$HOME/.config/scoop/config.json"
# backup files
if [[ ! -d "${OX_BACKUP}"/win ]]; then
    mkdir -p "$OX_BACKUP/win"
fi
OX_OXIDE[bkw]="$OX_BACKUP/win/winget.jsonc"
OX_OXIDE[bkwx]="$OX_BACKUP/win/Wingetfile.json"

up_winget() {
    echo "Update Scoop by ${OX_OXIDE[bkw]}"
    winget import -i "${OX_OXIDE[bkw]}"
}

back_winget() {
    echo "Backup Scoop by ${OX_OXIDE[bkw]}"
    winget export -o "${OX_OXIDE[bkw]}"
}

alias wis="winget install"
alias wus="winget uninstall"
alias wls="winget list"
alias wif="winget show"
alias wifs="winget --info"
alias wsc="winget search"

wup() {
    if [[ -z "$1" ]]; then
        winget upgrade '*'
    else
        winget upgrade "$1"
    fi
}

alias wups="winget source update"

alias wcf="winget settings"

# extension
alias wxa="winget source add"
alias wxrm="winget source remove"
alias wxls="winget source list"

##########################################################
# wsl
##########################################################

wlis() {
    if [[ -z "$1" ]]; then
        wsl --install
    else
        wsl --install -d "$1"
    fi
}

alias wlus="wslconfig /u"
alias wlls="wsl -l -v"
alias wllso="wsl -l -o"

wlv() {
    ver="$1"
    case $ver in
    2) wsl --set-version 1 ;;
    *) wsl --set-version 2 ;;
    esac
}

wlcl() {
    sys="$1"
    case $sys in
    kali)
        file="C:/Users/Ci/AppData/Local/Packages/KaliLinux.54290C8133FEE_ey8k8hqnwqnmg/LocalState/ext4.vhdx"
        ;;
    *)
        file="C:/Users/Ci/AppData/Local/Packages/CanonicalGroupLimited.Ubuntu20.04onWindows_79rhkp1fndgsc/LocalState/ext4.vhdx"
        ;;
    esac
    diskpart.exe
    select.exe vdisk file="$file"
    attach.exe vdisk readonly
    compact.exe vdisk
    detach.exe vdisk
}
