#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

export OX_JULIA_ENV_ACTIVE=${OX_JULIA_ENV_ACTIVE:-"${OX_JULIA_ENV[b]}"}

# default files
OX_OXYGEN[jl]=${OXIDIZER}/defaults/startup.jl
# system files
OX_ELEMENT[jl]=${JULIA_DEPOT_PATH}/config/startup.jl
# backup files
OX_OXIDE[bkjl]=${OX_BACKUP}/julia/startup.jl

# 1. trim \n;
# 2. add " to the head and the tail;
# 3. replace , with ", "
# 4. remove the extra " at the tail;
up_julia() {
    if [[ -z "$1" ]]; then
        local julia_env=${OX_JULIA_ENV[b]}
        local julia_backup=${OX_OXIDE[bkjlb]}
    elif [[ ${#1} -lt 4 ]]; then
        local julia_env=${OX_JULIA_ENV[$1]}
        local julia_backup=${OX_OXIDE[bkjl$1]}
    else
        if [[ -z "$2" ]]; then
            echo "Error: Second parameter is missing."
            exit 1
        fi
        local julia_env=$1
        local julia_backup=$2
    fi

    echo "Update Julia Env $julia_env by $julia_backup"
    pkgs=$(tr '\n' ', ' <"$julia_backup" | sd '^' '"' | sd ',$' '"' | sd ',' '","')
    cmd=$(echo 'using Pkg; Pkg.activate("$julia_env"); Pkg.add([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "$cmd"
    julia --eval "$cmd"
}

back_julia() {
    if [[ -z "$1" ]]; then
        local julia_env=${OX_JULIA_ENV[b]}
        local julia_backup=${OX_OXIDE[bkjlb]}
    elif [[ ${#1} -lt 4 ]]; then
        local julia_env=${OX_JULIA_ENV[$1]}
        local julia_backup=${OX_OXIDE[bkjl$1]}
    else
        if [[ -z "$2" ]]; then
            echo "Error: Second parameter is missing."
            exit 1
        fi
        local julia_env=$1
        local julia_backup=$2
    fi

    echo "Backup Julia Env $julia_env to $julia_backup"
    rg -o "\w.*=" <"$julia_env/Project.toml" | tr -d '= ' >"$julia_backup"
}

clean_julia() {
    if [[ -z "$1" ]]; then
        local julia_env=${OX_JULIA_ENV[b]}
        local julia_backup=${OX_OXIDE[bkjlb]}
    elif [[ ${#1} -lt 4 ]]; then
        local julia_env=${OX_JULIA_ENV[$1]}
        local julia_backup=${OX_OXIDE[bkjl$1]}
    else
        if [[ -z "$2" ]]; then
            echo "Error: Second parameter is missing."
            exit 1
        fi
        local julia_env=$1
        local julia_backup=$2
    fi

    echo "Cleanup Julia Env $julia_env by $julia_file"
    the_leaves=$(jllv "$julia_env")

    echo "$the_leaves" | while read -r line; do
        pkg=$(rg "$line" <"$julia_file")
        if [[ -z "$pkg" ]]; then
            echo "Removing $line"
            jlus "$line"
        fi
    done
    if [[ "$(echo "$the_leaves" | wc -w)" -eq "$(wc -w <"$julia_file")" ]] && [[ ${#the_leaves} -eq "$(wc -c <"$julia_file")" ]]; then
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

jleat() {
    export OX_JULIA_ENV_ACTIVE=${OX_JULIA_ENV[$1]}
    echo "Activate Julia Env $OX_JULIA_ENV_ACTIVE"
}

# install packages
jlis() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.activate(";;"); Pkg.add([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "$cmd"
    julia --eval "$cmd"
}

# uninstall packages
jlus() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.activate(";;"); Pkg.rm([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "$cmd"
    julia --eval "$cmd"
}

# update packages
jlup() {
    if [[ -z "$1" ]]; then
        cmd=$(echo 'using Pkg; Pkg.activate(";;"); Pkg.update()' | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    else
        pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
        cmd=$(echo 'using Pkg; Pkg.activate(";;"); Pkg.update([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    fi
    echo "$cmd"
    julia --eval "$cmd"
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
    cmd=$(echo 'using Pkg; Pkg.activate(";;"); using PkgDependency; PkgDependency.tree(",,") |> println' | sd ",," "$1" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "$cmd"
    julia --eval "$cmd"
}

jlrdp() {
    cmd=$(echo 'using Pkg; Pkg.activate(";;"); using PkgDependency; PkgDependency.tree(",,"; reverse=true) |> println' | sd ",," "$1" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "$cmd"
    julia --eval "$cmd"
}

jlpn() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.activate(";;"); Pkg.pin([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "$cmd"
    julia --eval "$cmd"
}

jlupn() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.activate(";;"); Pkg.free([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "$cmd"
    julia --eval "$cmd"
}

# calculate mature rate
jlmt() {
    num_total=$(rg -c "version =" <"${OX_JULIA_ENV_ACTIVE}/Manifest.toml")
    echo "total: $num_total"
    num_immature=$(rg -c '"0\.' <"${OX_JULIA_ENV_ACTIVE}/Manifest.toml")
    local mature_rate=$((100 - num_immature * 100 / num_total))
    echo "mature rate: $mature_rate %"
}

##########################################################
# project
##########################################################

# build project
jlb() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.activate(";;"); Pkg.build([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "$cmd"
    julia --eval "$cmd"
}

# test project
jlts() {
    pkgs=$(echo "$*" | sd '^' '"' | sd '$' '"' | sd ' ' '","' | sd '""' '')
    cmd=$(echo 'using Pkg; Pkg.activate(";;"); Pkg.test([,,])' | sd ",," "$pkgs" | sd ";;" "$OX_JULIA_ENV_ACTIVE")
    echo "$cmd"
    julia --eval "$cmd"
}
