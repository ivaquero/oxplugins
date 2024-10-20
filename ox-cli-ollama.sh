#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

alias olh="ollama help"

ol_host() {
    if [[ -z "$1" ]]; then
        export OLLAMA_HOST="127.0.0.1"
    else
        export OLLAMA_HOST="$1"
    fi
}

ol_origns() {
    if [[ -z "$1" ]]; then
        export OLLAMA_ORIGINS="\*"
    else
        export OLLAMA_ORIGINS="$1"
    fi
}

ol_max_models() {
    if [[ -z "$1" ]]; then
        export OLLAMA_MAX_LOADED_MODELS=2
    else
        export OLLAMA_MAX_LOADED_MODELS="$1"
    fi
}

ol_num_parallel() {
    if [[ -z "$1" ]]; then
        export OLLAMA_NUM_PARALLEL=4
    else
        export OLLAMA_NUM_PARALLEL="$1"
    fi
}

##########################################################
# local
##########################################################

alias olls="ollama list"
alias olif="ollama show"
alias ols="ollama start"
alias olr="ollama run"
alias ola="ollama create"
alias olrm="ollama rm"
alias olst="ollama ps"

##########################################################
# remote
##########################################################

alias olps="ollama push"
alias olpl="ollama pull"
