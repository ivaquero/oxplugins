#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

export JULIA_DEPOT_PATH=${JULIA_DEPOT_PATH:-"${HOME}/.julia"}

# system files
OX_ELEMENT[jl]=${JULIA_DEPOT_PATH}/config/startup.jl

OX_JULIA_ENV_BASE="${JULIA_DEPOT_PATH}/environments/v$(julia -v | rg -o "\d+\.\d+")"
OX_JULIA_ENV=$(jq .julia_env_shortcuts <"$OXIDIZER"/custom.json)
bkjlb=$(echo "$OX_OXIDE" | jq -r .jlb)

export OX_JULIA_ENV_ACTIVE=${OX_JULIA_ENV_ACTIVE:-"$OX_JULIA_ENV_BASE"}
# 1. trim \n;
# 2. add " to the head and the tail;
# 3. replace , with ", "
# 4. remove the extra " at the tail;
# shellcheck disable=SC2016
up_julia() {
    if [[ -z "$1" ]]; then
        local julia_env=$OX_JULIA_ENV_BASE
        local julia_backup=$bkjlb
    elif [[ ${#1} -lt 4 ]]; then
        # shellcheck disable=SC2155
        the_env=$(echo "$OX_JULIA_ENV" | jq -r ."$1")
        local julia_env=$HOME/$the_env
        # shellcheck disable=SC2155
        local julia_backup=${OX_BACKUP}/$(echo "$OX_OXIDE" | jq -r .bkjl"$1")
    else
        if [[ -z "$2" ]]; then
            echo "Error: Second parameter is missing."
        fi
        local julia_env=$1
        local julia_backup=$2
    fi

    echo "Update Julia Env $julia_env by $julia_backup"
    pkgs=$(tr '\n' ', ' <"$julia_backup" | sd '^' '"' | sd ',$' '"' | sd ',' '","')
    jleat "$julia_env"
    cmd=$(echo "using Pkg; Pkg.add([,,])" | sd ",," "$pkgs")
    echo "$cmd"
    julia --eval "$cmd"
}

back_julia() {
    if [[ -z "$1" ]]; then
        local julia_env=$OX_JULIA_ENV_BASE
        local julia_backup=$bkjlb
    elif [[ ${#1} -lt 4 ]]; then
        # shellcheck disable=SC2155
        the_env=$(echo "$OX_JULIA_ENV" | jq -r ."$1")
        local julia_env=$HOME/$the_env
        # shellcheck disable=SC2155
        local julia_backup=${OX_BACKUP}/$(echo "$OX_OXIDE" | jq -r .bkjl"$1")
    else
        if [[ -z "$2" ]]; then
            echo "Error: Second parameter is missing."
        fi
        local julia_env=$1
        local julia_backup=$2
    fi

    echo "Backup Julia Env $julia_env to $julia_backup"
    rg -o "\w.*=" <"$julia_env/Project.toml" | tr -d '= ' >"$julia_backup"
}

clean_julia() {
    if [[ -z "$1" ]]; then
        local julia_env=$OX_JULIA_ENV_BASE
        local julia_backup=$bkjlb
    elif [[ ${#1} -lt 4 ]]; then
        # shellcheck disable=SC2155
        the_env=$(echo "$OX_JULIA_ENV" | jq -r ."$1")
        local julia_env=$HOME/$the_env
        # shellcheck disable=SC2155
        local julia_backup=${OX_BACKUP}/$(echo "$OX_OXIDE" | jq -r .bkjl"$1")
    else
        if [[ -z "$2" ]]; then
            echo "Error: Second parameter is missing."
        fi
        local julia_env=$1
        local julia_backup=$2
    fi

    echo "Cleanup Julia Env $julia_env by $julia_backup"
    the_leaves=$(jllv "$julia_env")

    echo "$the_leaves" | while read -r line; do
        pkg=$(rg "$line" <"$julia_backup")
        if [[ -z "$pkg" ]]; then
            echo "Removing $line"
            jlus "$line"
        fi
    done
    if [[ "$(echo "$the_leaves" | wc -w)" -eq "$(wc -w <"$julia_backup")" ]] && [[ ${#the_leaves} -eq "$(wc -c <"$julia_backup")" ]]; then
        echo "Julia Env Cleanup Finished"
    fi
}

##########################################################
# packages
##########################################################

alias jl="julia --quiet"
alias jlh="julia --help"
alias jlr="julia --eval"
alias jlcl="julia --eval 'using Pkg; Pkg.gc()'"
alias jlst="julia --eval 'using Pkg; Pkg.status()'"

# activate environment
jleat() {
    if [[ -z $1 ]]; then
        julia_env=$OX_JULIA_ENV_BASE
    else
        the_env=$(echo "$OX_JULIA_ENV" | jq -r ."$1")
        julia_env=$HOME/$the_env
    fi

    export OX_JULIA_ENV_ACTIVE=$julia_env
    echo "Activate Julia Env $OX_JULIA_ENV_ACTIVE"
}

# diff environment
jldf() {
    if [[ -z $1 ]]; then
        julia_env=$OX_JULIA_ENV_BASE
    else
        the_env=$(echo "$OX_JULIA_ENV" | jq -r ."$1")
        julia_env=$HOME/$the_env
    fi

    echo "Enter Julia Env $julia_env"
    cd "$julia_env" || exit
    git diff --stat Manifest.toml
    lines=$(wc -l <Manifest.toml)
    echo " total lines: $lines"
    z -
}

# install packages
jlis() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.add([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --project="$OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

# uninstall packages
jlus() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.rm([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --project="$OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

# update packages
jlup() {
    if [[ -z "$1" ]]; then
        cmd='using Pkg; Pkg.update()'
    else
        pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
        cmd=$(echo 'using Pkg; Pkg.update([,,])' | sd ",," "$pkgs")
    fi
    echo "$cmd"
    julia --project="$OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

# list leave packages
jllv() {
    rg -o "\w+ =" <"$OX_JULIA_ENV_ACTIVE/Project.toml" | tr " =" " "
}

# list packages
jlls() {
    rg -o "deps\.\w+" <"$OX_JULIA_ENV_ACTIVE/Manifest.toml" | tr -d "deps\."
}

# dependencies of package
jldp() {
    cmd=$(echo 'using Pkg; using PkgDependency; PkgDependency.tree(",,") |> println' | sd ",," "$1")
    echo "$cmd"
    julia --project="$OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

jldpr() {
    cmd=$(echo 'using Pkg; using PkgDependency; PkgDependency.tree(",,"; reverse=true) |> println' | sd ",," "$1")
    echo "$cmd"
    julia --project="$OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

jlpn() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.pin([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --project="$OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

jlpnr() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.free([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --project="$OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

# calculate maturity
jlmt() {
    num_total=$(rg -c "version =" <"${OX_JULIA_ENV_ACTIVE}/Manifest.toml")
    echo "total: $num_total"
    num_immature=$(rg -c '"0\.' <"${OX_JULIA_ENV_ACTIVE}/Manifest.toml")
    local mature_rate=$((100 - num_immature * 100 / num_total))
    echo "maturity: $mature_rate %"
}

##########################################################
# project
##########################################################

# build project
jlb() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.build([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --project="$OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}

# test project
jlts() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.test([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --project="$OX_JULIA_ENV_ACTIVE" --eval "$cmd"
}
