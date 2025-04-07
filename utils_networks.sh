#!/bin/bash /bin/zsh
##########################################################
# Proxy Utils
##########################################################

OX_PROXY=$(jq .proxy_ports <"$OXIDIZER"/custom.json)

pxy() {
    if [[ -z "$1" ]]; then
        echo 'unset all proxies'
        unset https_proxy
        unset http_proxy
        unset all_proxy
    else
        if [[ ${#1} -lt 3 ]]; then
            # shellcheck disable=SC2155
            local port="$(echo "$OX_PROXY" | jq -r ."$1")"
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
    # shellcheck disable=SC2155
    export ALL_PROXY="https://$1:$(echo "$OX_PROXY" | jq -r ."$1")"
}
