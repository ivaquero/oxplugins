#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# system files
OX_ELEMENT[scs]="/etc/dnf/dnf.conf"
# backup files
OX_OXIDE[bkscs]=${OX_BACKUP}/unix/dnf.conf

##########################################################
# dnf
##########################################################

alias dif="dnf info"
alias dls="dnf list --installed"

alias dis="dnf install"
alias dus="dnf remove"
alias dup="dnf upgrade"
