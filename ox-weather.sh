#!/bin/bash /bin/zsh
# -a: all, -g: geographical, -d: day, -n: night
wttr() {
    case "$1" in
    -h)
        printf "param 1:\n city: new+york\n airport_code: muc \n resort: Eiffel+Tower\n ip address: @github.com\n help: help\n"
        printf "param 2:\n a: all\n d/n: day/night\n g: geographical\n f: format\n"
        ;;
    *)
        case "$2" in
        -a)
            curl "wttr.in/$1"
            ;;
        -d)
            curl "v2d.wttr.in/$1"
            ;;
        -n)
            curl "v2n.wttr.in/$1"
            ;;
        -g)
            curl "v3.wttr.in/$1"
            ;;
        *)
            curl "v2.wttr.in/$1"
            ;;
        esac
        ;;
    esac
}
