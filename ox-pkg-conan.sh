#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# system files
OX_ELEMENT[cn]=${HOME}/.conan/conan.conf
OX_ELEMENT[cnr]=${HOME}/.conan/remotes.json
OX_ELEMENT[cnd]=${HOME}/.conan/profiles/default
# backup files
if [[ ! -d "${OX_BACKUP}"/conan ]]; then
    mkdir -p -v "${OX_BACKUP}"/conan
fi
OX_OXIDE[bkcn]=${OX_BACKUP}/conan/conan.conf
OX_OXIDE[bkcnr]=${OX_BACKUP}/conan/remotes.json
OX_OXIDE[bkcnd]=${OX_BACKUP}/conan/profiles/default

##########################################################
# packages
##########################################################

alias cnh="conan help"
alias cnis="conan install"
alias cnus="conan remove"

cnsc() {
    local help_msg="Usage: cnsc [-m <package>] [package]\n
    Search for packages in Conan.
    -m, --remote   Search in remote 'conancenter'."

    if [[ $# -eq 0 ]]; then
        echo "$help_msg"
        return 1
    fi

    case "$1" in
    -m | --remote)
        if [[ -z "$2" ]]; then
            echo "Error: Package name is required after -m option."
            echo "$help_msg"
            return 1
        else
            conan search --remote=conancenter "$2"
        fi
        ;;
    *)
        conan search "$1"
        ;;
    esac
}

cndl() {
    local help_msg="Usage: cndl [-m <package>] [package]\n
    Search for packages in Conan.
    -m, --remote   Search in remote 'conancenter'."

    if [[ $# -eq 0 ]]; then
        echo "$help_msg"
        return 1
    fi

    case "$1" in
    -m | --remote)
        if [[ -z "$2" ]]; then
            echo "Error: Package name is required after -m option."
            echo "$help_msg"
            return 1
        else
            conan download --remote=conancenter "$2"
        fi
        ;;
    *)
        conan download "$1"
        ;;
    esac
}

alias cndp="conan graph"
alias cncf="conan config"

##########################################################
# extension
##########################################################

alias cnxa="conan remote add"
alias cnxrm="conan remote remove"
alias cnxls="conan remote list"

##########################################################
# project
##########################################################

alias cncr="conan create"
alias cnb="conan build"
alias cnif="conan inspect"
alias cnpb="conan publish"
alias cnts="conan test"
