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
OX_ELEMENT[w]="$HOME/AppData/Local/Packages/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe/LocalState/settings.json"

bkw=$(echo "$OX_OXIDE" | jq -r .bks)
up_winget() {
    echo "Update Winget by $bkw"
    winget import -i "$bkw"
}

back_winget() {
    echo "Backup Winget by $bkw"
    winget export -o "$bkw"
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
