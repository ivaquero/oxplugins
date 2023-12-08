#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# default files
OX_OXYGEN[oxc]=${OXIDIZER}/defaults/.condarc
# system files
OX_ELEMENT[c]=${HOME}/.condarc
# backup files
OX_OXIDE[bkc]=${OX_BACKUP}/conda/.condarc

if test ! "$(command -v mamba)"; then
    echo "please install mamba first"
fi

up_conda() {
    if [[ -z "$1" ]]; then
        local conda_env=base
        local conda_file=${OX_OXIDE[bkceb]}
    elif [[ ${#1} -lt 4 ]]; then
        local conda_env=${OX_CONDA_ENV[$1]}
        local conda_file=${OX_OXIDE[bkce$1]}
    else
        local conda_env=$1
        local conda_file=$2
    fi
    echo "Update Conda Env $conda_env by $conda_file"
    pkgs=$(tr '\n' ' ' <"$conda_file")
    echo "Installing $pkgs"
    eval "mamba install $pkgs"
}

back_conda() {
    if [[ -z "$1" ]]; then
        local conda_env=base
        local conda_file=${OX_OXIDE[bkceb]}
    elif [[ ${#1} -lt 4 ]]; then
        local conda_env=${OX_CONDA_ENV[$1]}
        local conda_file=${OX_OXIDE[bkce$1]}
    else
        local conda_env=$1
        local conda_file=$2
    fi
    echo "Backup Conda Env $conda_env to $conda_file"
    conda tree -n "$conda_env" leaves | sort >"$conda_file"
}

clean_conda() {
    if [[ -z "$1" ]]; then
        local conda_env=base
        local conda_file=${OX_OXIDE[bkceb]}
    elif [[ ${#1} -lt 4 ]]; then
        local conda_env=${OX_CONDA_ENV[$1]}
        local conda_file=${OX_OXIDE[bkce$1]}
    else
        local conda_env=$1
        local conda_file=$2
    fi

    echo "Cleanup Conda Env $conda_env by $conda_file"
    the_leaves=$(conda tree -n "$conda_env" leaves)

    echo "$the_leaves" | while read -r line; do
        pkg=$(rg "$line" <"$conda_file")
        if [ -z "$pkg" ]; then
            echo "Removing $line"
            mamba remove -n "$conda_env" "$line" --quiet --yes
        fi
    done
    if [ "$(echo "$the_leaves" | wc -w)" -eq "$(wc -w <"$conda_file")" ] && [ "$(echo "$the_leaves" | wc -c)" -eq "$(wc -c <"$conda_file")" ]; then
        echo "Conda Env Cleanup Finished"
    fi
}

##########################################################
# packages
##########################################################

alias ch="conda --help"
alias ccf="conda config"
alias cif="conda info"
alias cis="mamba install"
alias cus="mamba remove"
alias csc="mamba search"
# specific
alias cdp="mamba repoquery depends"
alias crdp="mamba repoquery whoneeds"

# clean packages
ccl() {
    case "$1" in
    -l) conda clean --logfiles ;;
    -i) conda clean --index-cache ;;
    -p) conda clean --packages ;;
    -t) conda clean --tarballs ;;
    -f) conda clean --force-pkgs-dirs ;;
    -a) conda clean --all ;;
    *) conda clean --packages && conda clean --tarballs ;;
    esac
}

# update packages
# $1=name
cup() {
    if [[ -z "$1" ]]; then
        mamba update --all
    else
        ceat "$1"
        mamba update --all
        conda deactivate
    fi
}

# list packages
# $1=name
cls() {
    if [[ -z "$1" ]]; then
        conda list
    elif [[ ${#1} -lt 4 ]]; then
        conda list -n "${OX_CONDA_ENV[$1]}"
    else
        conda list -n "$1"
    fi
}

# list leave packages
# $1=name
clv() {
    if [[ -z "$1" ]]; then
        conda-tree leaves | sort
    elif [[ ${#1} -lt 4 ]]; then
        conda-tree -n "${OX_CONDA_ENV[$1]}" leaves | sort
    else
        conda-tree -n "$1" leaves | sort
    fi
}

cmt() {
    num_total=$(cls "$1" | wc -l)
    echo "total: $num_total"
    num_immature=$(cls "$1" | rg -c "\s0\.\d")
    local mature_rate=$((100 - num_immature * 100 / num_total))
    echo "mature rate: $mature_rate %"
}

##########################################################
# extension
##########################################################

alias cxa="conda config --add channels"
alias cxrm="conda config --remove channels"
alias cxls="conda config --get channels"

##########################################################
# project
##########################################################

alias cii="conda init"
alias cr="conda run"

##########################################################
# environments
##########################################################

# check environment health
cck() {
    if [[ -z "$1" ]]; then
        conda doctor
    elif [[ ${#1} -lt 4 ]]; then
        conda doctor -n "${OX_CONDA_ENV[$1]}"
    else
        conda doctor -n "$1"
    fi
}

# activate environment: $1=name
ceat() {
    if [[ -z "$1" ]]; then
        conda activate base && clear
    elif [[ ${#1} -lt 3 ]]; then
        conda activate "${OX_CONDA_ENV[$1]}"
    else
        conda activate "$1" && clear
    fi
}

# reactivate environment: $1=name
cerat() {
    conda deactivate
    ceat "$1"
}

# create environment: $1=name
cecr() {
    if [[ ${#1} -lt 3 ]]; then
        conda create -n "${OX_CONDA_ENV[$1]}"
    else
        conda create -n "$1"
    fi
    ceat "$1"
}

# delete environment: $1=name
cerm() {
    conda deactivate
    if [[ ${#1} -lt 3 ]]; then
        conda env remove -n "${OX_CONDA_ENV[$1]}"
    else
        conda env remove -n "$1"
    fi
}

# change environment subdir
cesd() {
    if [[ $(uname) = "Darwin" ]]; then
        case "$1" in
        i*) conda env config vars set CONDA_SUBDIR=osx-64 ;;
        a*) conda env config vars set CONDA_SUBDIR=osx-arm64 ;;
        esac
    else
        case "$1" in
        i*) conda env config vars set CONDA_SUBDIR=linux-64 ;;
        a*) conda env config vars set CONDA_SUBDIR=linux-aarch64 ;;
        p*) conda env config vars set CONDA_SUBDIR=linux-ppc64le ;;
        s*) conda env config vars set CONDA_SUBDIR=linux-s390x ;;
        esac
    fi
}

# export environment: $1=name
ceep() {
    os=$("$(uname)" | tr "[:upper:]" "[:lower:]")

    if [[ -z "$1" ]]; then
        local conda_env=base
    elif [[ ${#1} -lt 3 ]]; then
        local conda_env="${OX_CONDA_ENV[$1]}"
    else
        local conda_env=$1
    fi
    conda env export -n "$conda_env" -f "${OXIDIZER}"/defaults/"$conda_env"-"$os"-"$(arch)".yml
}

# rename environment: $1=old_name, $2=new_name
cern() {
    if [[ "$1" == *"/"* ]]; then
        conda rename --prefix "$1" "$2"
    else
        conda rename --name "$1" "$2"
    fi
}

alias cels="conda env list"
alias ceq="conda deactivate"
alias cedf="conda compare"
