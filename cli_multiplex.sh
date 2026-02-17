#!/bin/bash /bin/zsh
##########################################################
# zellij
##########################################################

# system files
OX_ELEMENT[zj]=${HOME}/.config/zellij/config.kdl

alias zjh="zellij help"
alias zja="zellij attach"
alias zjrm="zellij delete-session"
alias zjq="zellij kill-session"
alias zjls="zellij list-sessions"

alias zjed="zellij edit"
alias zjr="zellij run"

##########################################################
# tmux
##########################################################

OX_ELEMENT[tx]=${HOME}/.tmux.conf

alias txn="tmux new -s"
alias txa="tmux attach -t"
alias txq="tmux kill-session -t"
alias txls="tmux ls"

alias txrn="tmux rename-session -t"

alias txsp="tmux split-window"
alias txsph="tmux split-window -h"
