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
OX_ELEMENT[jlp]=${JULIA_DEPOT_PATH}/environments/v${JULIA_VERSION}/Project.toml
OX_ELEMENT[jlm]=${JULIA_DEPOT_PATH}/environments/v${JULIA_VERSION}/Manifest.toml
# backup files
OX_OXIDE[bkjl]=${OX_BACKUP}/julia/startup.jl
OX_OXIDE[bkjlx]=${OX_BACKUP}/julia/julia-pkgs.txt

# 1. trim \n;
# 2. add " to the head and the tail;
# 3. replace , with ", "
# 4. remove the extra " at the tail;
up_julia() {
    echo "Update Julia by ${OX_OXIDE[bkjlx]}"
    pkgs=$(tr '\n' ', ' <"${OX_OXIDE[bkjlx]}" | sed 's/$/"/g' | sed 's/^/"/g' | sed 's/,/", "/g' | sed 's/, ""//g')
    cmd=$(echo 'using Pkg; Pkg.add([,,])' | sed "s/,,/$pkgs/g")
    echo "$cmd"
    julia --eval "$cmd"
}

back_julia() {
    echo "Backup Julia to ${OX_OXIDE[bkjlx]}"
    rg -o "\w.*=" <"${OX_ELEMENT[jlp]}" | tr -d '= ' >"${OX_OXIDE[bkjlx]}"
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
    pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    cmd=$(echo 'using Pkg; Pkg.add([,,])' | sed "s/,,/$pkgs/g")
    echo "$cmd"
    julia --eval "$cmd"
}

# uninstall packages
jlus() {
    pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    cmd=$(echo 'using Pkg; Pkg.rm([,,])' | sed "s/,,/$pkgs/g")
    echo "$cmd"
    julia --eval "$cmd"
}

# update packages
jlup() {
    if [[ -z "$1" ]]; then
        julia --eval "using Pkg; Pkg.update()"
    else
        pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
        cmd=$(echo 'using Pkg; Pkg.update([,,])' | sed "s/,,/$pkgs/g")
        echo "$cmd"
        julia --eval "$cmd"
    fi
}

# list leave packages
jllv() {
    rg -o "\w+ =" <"${OX_ELEMENT[jlp]}" | tr " =" " "
}

# list packages
jlls() {
    rg -o "deps\.\w+" <"${OX_ELEMENT[jlm]}" | tr -d "deps\."
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
    pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    cmd=$(echo 'using Pkg; Pkg.pin([,,])' | sed "s/,,/$pkgs/g")
    echo "$cmd"
    julia --eval "$cmd"
}

jlupn() {
    pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    cmd=$(echo 'using Pkg; Pkg.free([,,])' | sed "s/,,/$pkgs/g")
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
    pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    cmd=$(echo 'using Pkg; Pkg.build([,,])' | sed "s/,,/$pkgs/g")
    echo "$cmd"
    julia --eval "$cmd"
}

# test project
jlts() {
    pkgs=$(echo \"$@\" | sed 's/ /\", \"/g')
    cmd=$(echo 'using Pkg; Pkg.test([,,])' | sed "s/,,/$pkgs/g")
    echo "$cmd"
    julia --eval "$cmd"
}
