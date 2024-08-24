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
# repository management
##########################################################

get_default_branch() {
    git remote show origin | grep 'HEAD branch' | cut -d ' ' -f5
}

# git republish
grpbl() {
    git remote add origin "$1"
    local branch_d=$(get_default_branch)
    git pull "$1" "$branch_d"
    git push --set-upstream origin "$branch_d"
}

# clean history
gclhs() {
    git reset --hard HEAD~1
    local branch_d=$(get_default_branch)
    git checkout --orphan origin/"$branch_d"
    git add -A
    git commit -am "🎉 New Start"
    git branch -D "$branch_d"
    git branch -m "$branch_d"
    git push -f origin "$branch_d"
}
