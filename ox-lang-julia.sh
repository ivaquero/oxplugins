#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

export JULIA_DEPOT_PATH=${JULIA_DEPOT_PATH:-"${HOME}/.julia"}

JULIA_VERSION=$(julia -v | rg -o "\d+\.\d+")

# default files
OX_OXYGEN[jl]=${OXIDIZER}/defaults/startup.jl
# system files
OX_ELEMENT[jl]=${JULIA_DEPOT_PATH}/config/startup.jl
OX_ELEMENT[jlbp]=${JULIA_DEPOT_PATH}/environments/v${JULIA_VERSION}/Project.toml
OX_ELEMENT[jlbm]=${JULIA_DEPOT_PATH}/environments/v${JULIA_VERSION}/Manifest.toml
# backup files
OX_OXIDE[bkjl]=${OX_BACKUP}/julia/startup.jl
OX_OXIDE[bkjlb]=${OX_BACKUP}/julia/julia-base.txt

# 1. trim \n;
# 2. add " to the head and the tail;
# 3. replace , with ", "
# 4. remove the extra " at the tail;
up_julia() {
    if [[ -z "$1" ]]; then
        local julia_backup=${OX_OXIDE[bkjlb]}
    elif [[ ${#1} -lt 4 ]]; then
        local julia_env=${OX_JULIA_ENV[$1]}
        local julia_backup=${OX_OXIDE[bkjl$1]}
    else
        local julia_env=$1
        local julia_backup=$2
    fi

    echo "Update Julia Env $julia_env by $julia_backup"
    pkgs=$(tr '\n' ', ' <"$julia_backup" | sd '^' '"' | sd ',$' '"' | sd ',' '","')
    cmd=$(echo 'using Pkg; Pkg.add([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --eval "$cmd"
}

back_julia() {
    if [[ -z "$1" ]]; then
        local julia_backup=${OX_OXIDE[bkjlb]}
        local julia_backup_proj=${OX_ELEMENT[jlbp]}
    elif [[ ${#1} -lt 4 ]]; then
        local julia_env=${OX_JULIA_ENV[$1]}
        local julia_backup=${OX_OXIDE[bkjl$1]}
    else
        local julia_env=$1
        local julia_backup=$2
    fi
    echo "Backup Julia Julia Env $julia_env to $julia_backup"
    rg -o "\w.*=" <"$julia_backup_proj" | tr -d '= ' >"$julia_backup"
}

##########################################################
# packages
##########################################################

alias jl="julia --quiet"
alias jlh="julia --help"
alias jlr="julia --eval"
alias jlcl="julia --eval 'using Pkg; Pkg.gc()'"
alias jlst="julia --eval 'using Pkg; Pkg.status()'"

# install packages
jlis() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.add([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --eval "$cmd"
}

# uninstall packages
jlus() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.rm([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --eval "$cmd"
}

# update packages
jlup() {
    if [[ -z "$1" ]]; then
        julia --eval "using Pkg; Pkg.update()"
    else
        pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
        cmd=$(echo 'using Pkg; Pkg.update([,,])' | sd ",," "$pkgs")
        echo "$cmd"
        julia --eval "$cmd"
    fi
}

# list leave packages
jllv() {
    rg -o "\w+ =" <"${OX_ELEMENT[jlbp]}" | tr " =" " "
}

# list packages
jlls() {
    rg -o "deps\.\w+" <"${OX_ELEMENT[jlbm]}" | tr -d "deps\."
}

# dependencies of package
jldp() {
    cmd=$(echo "using PkgDependency; PkgDependency.tree(\"$1\") |> println")
    echo "$cmd"
    julia --eval "$cmd"
}

jlrdp() {
    cmd=$(echo "using PkgDependency; PkgDependency.tree(\"$1\"; reverse=true) |> println")
    echo "$cmd"
    julia --eval "$cmd"
}

jlpn() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.pin([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --eval "$cmd"
}

jlupn() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.free([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --eval "$cmd"
}

# calculate mature rate
jlmt() {
    num_total=$(rg -c "version =" <"${OX_ELEMENT[jlm]}")
    echo "total: $num_total"
    num_immature=$(rg -c '"0\.' <"${OX_ELEMENT[jlm]}")
    local mature_rate=$((100 - num_immature * 100 / num_total))
    echo "mature rate: $mature_rate %"
}

##########################################################
# project
##########################################################

# build project
jlb() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.build([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --eval "$cmd"
}

# test project
jlts() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.test([,,])' | sd ",," "$pkgs")
    echo "$cmd"
    julia --eval "$cmd"
}
