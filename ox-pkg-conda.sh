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

if test "$(command -v micromamba)"; then
    export OX_CONDA="micromamba"
elif test "$(command -v mamba)"; then
    export OX_CONDA="mamba"
elif test "$(command -v conda)"; then
    export OX_CONDA="conda"
else
    echo "No conda package manager found"
    exit 1
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
    eval "$OX_CONDA install $pkgs"
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

alias ch="$OX_CONDA --help"
alias ccf="$OX_CONDA config"
alias cif="$OX_CONDA info"
alias cis="$OX_CONDA install"
alias cus="$OX_CONDA remove"
alias csc="$OX_CONDA search"
# specific
alias cdp="$OX_CONDA repoquery depends"
alias cdpr="$OX_CONDA repoquery whoneeds"

# clean packages
ccl() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: ccl [-h|-l|-i|-p|-t|-f|-a]..."
        echo "Missing flag, executing greedy cleanup"
        $OX_CONDA clean --all && $OX_CONDA clean --tarballs
    fi

    while getopts "hliptfa:" opt; do
        case $opt in
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

        \?)
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
    else
        ceat "$1"
        $OX_CONDA update --all
        $OX_CONDA deactivate
    fi
}

# list packages
# $1=name
cls() {
    if [[ -z "$1" ]]; then
        $OX_CONDA list
    elif [[ ${#1} -lt 4 ]]; then
        $OX_CONDA list -n "${OX_CONDA_ENV[$1]}"
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

alias cxa="$OX_CONDA config --add channels"
alias cxrm="$OX_CONDA config --remove channels"
alias cxls="$OX_CONDA config --get channels"

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

alias cr="$OX_CONDA run"

##########################################################
# environments
##########################################################

# check environment health
cck() {
    case $OX_CONDA in
    conda)
        if [[ -z "$1" ]]; then
            conda doctor
        elif [[ ${#1} -lt 4 ]]; then
            conda doctor -n "${OX_CONDA_ENV[$1]}"
        else
            conda doctor -n "$1"
        fi
        ;;
    *) exit 1 ;;
    esac
}

# activate environment: $1=name
ceat() {
    if [[ -z "$1" ]]; then
        $OX_CONDA activate base && clear
    elif [[ ${#1} -lt 3 ]]; then
        $OX_CONDA activate "${OX_CONDA_ENV[$1]}"
    else
        $OX_CONDA activate "$1" && clear
    fi
}

# reactivate environment: $1=name
cerat() {
    case $OX_CONDA in
    micromamba | mamba)
        $OX_CONDA activate
        ;;
    conda)
        conda deactivate
        ;;
    esac
    ceat "$1"
}

# create environment: $1=name
cecr() {
    if [[ ${#1} -lt 3 ]]; then
        $OX_CONDA create -n "${OX_CONDA_ENV[$1]}"
    else
        $OX_CONDA create -n "$1"
    fi
    ceat "$1"
}

# delete environment: $1=name
cerm() {
    conda deactivate
    if [[ ${#1} -lt 3 ]]; then
        $OX_CONDA env remove -n "${OX_CONDA_ENV[$1]}"
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
        local conda_env="${OX_CONDA_ENV[$1]}"
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

ceq() {
    case $OX_CONDA in
    micromamba | mamba)
        $OX_CONDA activate
        ;;
    conda)
        conda deactivate
        ;;
    esac
}

alias cels="$OX_CONDA env list"
alias cedf="conda compare"
