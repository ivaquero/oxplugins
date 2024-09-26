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
git_clean_history() {
    git reset --hard HEAD~1
    git checkout --orphan origin/"$1"
    git add -A
    git commit -am "🎉 New Start"
    git branch -D "$1"
    git branch -m "$1"
    git push -f origin "$1"
}
