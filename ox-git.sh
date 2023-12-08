#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

export GPG_TTY=$(tty)

# default files
OX_OXYGEN[oxg]=${OXIDIZER}/defaults/.gitconfig
# system files
OX_ELEMENT[g]=${HOME}/.gitconfig

##########################################################
# project management
##########################################################

get_default_branch() {
    git remote show origin | grep 'HEAD branch' | cut -d' ' -f5
}

# git republish
grpbl() {
    git remote add origin "$1"
    local dbranch=get_default_branch
    git pull "$1" "$dbranch"
    git push --set-upstream origin "$dbranch"
}

##########################################################
# repository management
##########################################################

# clean history
gclhs() {
    git reset --hard HEAD~1
    local dbranch=get_default_branch
    git checkout --orphan origin/"$dbranch"
    git add -A
    git commit -am "🎉 New Start"
    git branch -D "$dbranch"
    git branch -m "$dbranch"
    git push -f origin "$dbranch"
}
