#!/bin/bash /bin/zsh
##########################################################
# Proxy Utils
##########################################################

# px=proxy
pxy() {
    if [[ -z "$1" ]]; then
        echo 'unset all proxies'
        unset https_proxy
        unset http_proxy
        unset all_proxy
    else
        if [[ ${#1} -lt 3 ]]; then
            local port=${OX_PROXY[$1]}
        else
            local port=$1
        fi
        echo "using port $port"
        export https_proxy=http://127.0.0.1:$port
        export http_proxy=http://127.0.0.1:$port
        export all_proxy=socks5://127.0.0.1:$port
    fi
}

##########################################################
# wsl
##########################################################

# host list
host_ls() {
    rg "nameserver" </etc/resolv.conf | cut -f 2 -d " "
}

# host proxy
host_pxy() {
    export ALL_PROXY="https://$1:${OX_PROXY[$2]}"
}
