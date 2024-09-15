#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

# shellcheck disable=SC2155
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
# shellcheck disable=SC2155
git_repub() {
    git remote add origin "$1"
    local branch_d=$(get_default_branch)
    git pull "$1" "$branch_d"
    git push --set-upstream origin "$branch_d"
}

# git sync
git_sync() {
    if [[ -z "$1" ]]; then
        local branch_d=$(get_default_branch)
        local branch="$branch_d"
    else
        local branch="$1"
    fi

    git pull upstream "$branch"
    git push origin "$branch"
}

# clean branch
git_clean_branch() {

    case $1 in
    -f)
        list="-l"
        flag="-D"
        find="$2"
        ;;
    -r)
        list="-r"
        flag="-r -d"
        find="$1"
        ;;
    -rf)
        list="-r"
        flag="-r -D"
        find="$1"
        ;;
    *)
        list="-l"
        flag="-d"
        find="$1"
        ;;
    esac

    for br in $(git branch "$list" | rg "$find"); do
        git branch "$flag" "$br"
    done
    git branch "$list"
}

# clean history
# shellcheck disable=SC2155
git_clean_history() {
    git reset --hard HEAD~1
    local branch_d=$(get_default_branch)
    git checkout --orphan origin/"$branch_d"
    git add -A
    git commit -am "🎉 New Start"
    git branch -D "$branch_d"
    git branch -m "$branch_d"
    git push -f origin "$branch_d"
}
