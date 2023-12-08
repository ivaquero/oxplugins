#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

OX_OXYGEN[oxhx]=${OXIDIZER}/defaults/helix.toml
# system files
OX_ELEMENT[hx]=${HOME}/.config/helix/config.toml
OX_ELEMENT[hxl]=${HOME}/.config/helix/languages.toml
# backup files
OX_OXIDE[bkhx]=${OX_BACKUP}/helix/config.toml
OX_OXIDE[bkhxl]=${OX_BACKUP}/helix/languages.toml

##########################################################
# main
##########################################################

alias hxh="hx --help"
alias hxck="hx --health"

# specific
alias hxtt="hx --tutor"
