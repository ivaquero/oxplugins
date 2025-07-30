#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# system files
OX_ELEMENT[c]=${HOME}/.condarc

if command -v mamba >/dev/null 2>&1; then
    export OX_CONDA="mamba"
elif command -v conda >/dev/null 2>&1; then
    export OX_CONDA="conda"
else
    export OX_CONDA="micromamba"
    brew install micromamba
    case ${SHELL} in
    *zsh)
        eval "$(micromamba shell hook --shell zsh)"
        ;;
    *bash)
        eval "$(micromamba shell hook --shell bash)"
        ;;
    esac
fi

OX_CONDA_ENV=$(jq .conda_env_shortcuts <"$OXIDIZER"/custom.json)
bkceb=${OX_BACKUP}/$(echo "$OX_OXIDE" | jq -r .bkceb)

up_conda() {
    if [[ -z "$1" ]]; then
        local conda_env=base
        local conda_file=$bkceb
    elif [[ ${#1} -lt 4 ]]; then
        # shellcheck disable=SC2155
        local conda_env=$(echo "$OX_CONDA_ENV" | jq -r ."$1")
        # shellcheck disable=SC2155
        local conda_file=${OX_BACKUP}/$(echo "$OX_OXIDE" | jq -r .bkce"$1")
    else
        local conda_env=$1
        local conda_file=$2
    fi
    echo "Update Conda Env $conda_env by $conda_file"
    pkgs=$(tr '\n' ' ' <"$conda_file")
    echo "Installing $pkgs"
    eval "$OX_CONDA install $pkgs"
}

back_conda() {
    if [[ -z "$1" ]]; then
        local conda_env=base
        local conda_file=$bkceb
    elif [[ ${#1} -lt 4 ]]; then
        # shellcheck disable=SC2155
        local conda_env=$(echo "$OX_CONDA_ENV" | jq -r ."$1")
        # shellcheck disable=SC2155
        local conda_file=${OX_BACKUP}/$(echo "$OX_OXIDE" | jq -r .bkce"$1")
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
        local conda_file=$bkceb
    elif [[ ${#1} -lt 4 ]]; then
        # shellcheck disable=SC2155
        local conda_env=$(echo "$OX_CONDA_ENV" | jq -r ."$1")
        # shellcheck disable=SC2155
        local conda_file=${OX_BACKUP}/$(echo "$OX_OXIDE" | jq -r .bkce"$1")
    else
        local conda_env=$1
        local conda_file=$2
    fi

    echo "Cleanup Conda Env $conda_env by $conda_file"
    the_leaves=$(conda tree -n "$conda_env" leaves)

    echo "$the_leaves" | while read -r line; do
        pkg=$(rg "$line" <"$conda_file")
        if [[ -z "$pkg" ]]; then
            echo "Removing $line"
            $OX_CONDA remove -n "$conda_env" "$line" --quiet --yes
        fi
    done
    if [[ "$(echo "$the_leaves" | wc -w)" -eq "$(wc -w <"$conda_file")" ]] && [[ ${#the_leaves} -eq "$(wc -c <"$conda_file")" ]]; then
        echo "Conda Env Cleanup Finished"
    fi
}

##########################################################
# packages
##########################################################

ch() {
    $OX_CONDA --help "$@"
}

ccf() {
    $OX_CONDA config "$@"
}
cis() {
    $OX_CONDA install "$@"
}
cus() {
    $OX_CONDA remove "$@"
}

# clean packages
ccl() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: ccl [-h|-l|-i|-p|-t|-f|-a]..."
        echo "Missing flag, executing greedy cleanup"
        $OX_CONDA clean --all && $OX_CONDA clean --tarballs
    fi

    while getopts "hliptfa:" opt; do
        case "$opt" in
        h)
            echo "Options:"
            echo "  -h              Help information."
            echo "  -l              Remove cached log files."
            echo "  -i              Remove cached index files."
            echo "  -p              Remove unused packages."
            echo "  -t              Remove tarball cache."
            echo "  -f              Force removal of unused pkgs dirs."
            echo "  -a              Perform all cleaning actions."
            return 1
            ;;
        l)
            $OX_CONDA clean --logfiles
            ;;
        i)
            $OX_CONDA clean --index-cache
            ;;
        p)
            $OX_CONDA clean --packages
            ;;
        t)
            $OX_CONDA clean --tarballs
            ;;
        f)
            $OX_CONDA clean --force-pkgs-dirs
            ;;
        a)
            $OX_CONDA clean --all
            ;;
        *)
            echo "Invalid option: -$OPTARG"
            echo "Usage: ccl [-h|-l|-i|-p|-t|-f|-a]..."
            ;;
        esac
    done
}

# update packages
# $1=name
cup() {
    if [[ -z "$1" ]]; then
        $OX_CONDA update --all
    elif [[ ${#1} -lt 4 ]]; then
        $OX_CONDA update --all -n "$(echo "$OX_CONDA_ENV" | jq -r ."$1")"
    else
        $OX_CONDA update --all -n "$1"
    fi
}

##########################################################
# info
##########################################################

cif() {
    $OX_CONDA info
}
csc() {
    $OX_CONDA search "$1"
}

# list packages
# $1=name
cls() {
    if [[ -z "$1" ]]; then
        $OX_CONDA list
    elif [[ ${#1} -lt 4 ]]; then
        $OX_CONDA list -n "$(echo "$OX_CONDA_ENV" | jq -r ."$1")"
    else
        $OX_CONDA list -n "$1"
    fi
}

# list leave packages
# $1=name
clv() {
    if [[ -z "$1" ]]; then
        conda-tree leaves | sort
    elif [[ ${#1} -lt 4 ]]; then
        conda-tree -n "$(echo "$OX_CONDA_ENV" | jq -r ."$1")" leaves | sort
    else
        conda-tree -n "$1" leaves | sort
    fi
}

# specific
cdp() {
    $OX_CONDA repoquery depends "$1"
}
cdpr() {
    $OX_CONDA repoquery whoneeds "$1"
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

cxa() {
    $OX_CONDA config --add channels "$@"
}
cxrm() {
    $OX_CONDA config --remove channels "$@"
}
cxls() {
    $OX_CONDA config --get channels "$@"
}

##########################################################
# project
##########################################################

cii() {
    case $OX_CONDA in
    micromamba | mamba)
        $OX_CONDA shell init "$@"
        ;;
    conda)
        conda init "$@"
        ;;
    esac
}

cr() {
    $OX_CONDA run "$@"
}

##########################################################
# environments
##########################################################

# check environment health
alias cck="conda doctor"

# activate environment: $1=name
ceat() {
    if [[ -z "$1" ]]; then
        $OX_CONDA activate base && clear
    elif [[ ${#1} -lt 3 ]]; then
        $OX_CONDA activate "$(echo "$OX_CONDA_ENV" | jq -r ."$1")"
    else
        $OX_CONDA activate "$1" && clear
    fi
}

ceq() {
    $OX_CONDA deactivate
}
cels() {
    $OX_CONDA env list
}

# reactivate environment: $1=name
cerat() {
    ceq
    ceat "$1"
}

# create environment: $1=name
cecr() {
    if [[ ${#1} -lt 3 ]]; then
        $OX_CONDA create -n "$(echo "$OX_CONDA_ENV" | jq -r ."$1")"
    else
        $OX_CONDA create -n "$1"
    fi
    ceat "$1"
}

# delete environment: $1=name
cerm() {
    ceq
    if [[ ${#1} -lt 3 ]]; then
        $OX_CONDA env remove -n "$(echo "$OX_CONDA_ENV" | jq -r ."$1")"
    else
        $OX_CONDA env remove -n "$1"
    fi
}

# change environment subdir
cesd() {
    if [[ $(uname) = "Darwin" ]]; then
        case "$1" in
        i*) $OX_CONDA env config vars set CONDA_SUBDIR=osx-64 ;;
        a*) $OX_CONDA env config vars set CONDA_SUBDIR=osx-arm64 ;;
        esac
    elif [[ $(uname) = "Linux" ]]; then
        case "$1" in
        i*) $OX_CONDA env config vars set CONDA_SUBDIR=linux-64 ;;
        a*) $OX_CONDA env config vars set CONDA_SUBDIR=linux-aarch64 ;;
        p*) $OX_CONDA env config vars set CONDA_SUBDIR=linux-ppc64le ;;
        s*) $OX_CONDA env config vars set CONDA_SUBDIR=linux-s390x ;;
        esac
    fi
}

# export environment: $1=name
ceep() {
    os=$("$(uname)" | tr "[:upper:]" "[:lower:]")

    if [[ -z "$1" ]]; then
        local conda_env=base
    elif [[ ${#1} -lt 3 ]]; then
        # shellcheck disable=SC2155
        local conda_env="$(echo "$OX_CONDA_ENV" | jq -r ."$1")"
    else
        local conda_env=$1
    fi
    $OX_CONDA env export -n "$conda_env" -f "${OXIDIZER}"/defaults/"$conda_env"-"$os"-"$(arch)".yml
}

# rename environment: $1=old_name, $2=new_name
cern() {
    if [[ "$1" == *"/"* ]]; then
        $OX_CONDA rename --prefix "$1" "$2"
    else
        $OX_CONDA rename --name "$1" "$2"
    fi
}

alias cedf="conda compare"
