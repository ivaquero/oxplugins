#!/bin/bash /bin/zsh
##########################################################
# config
##########################################################

OX_ELEMENT[jr]="${HOME}/.jupyter/jupyter_notebook_config.py"

##########################################################
# main
##########################################################

alias jrh="jupyter --help"
alias jrn="jupyter notebook"
alias jrncf="jupyter notebook --generate-config"
alias jrl="jupyter lab"

if [[ $(uname) = "Darwin" ]]; then
    jrcl() {
        echo "Cleaning up Jupyter Runtime Cache."
        rm -rfv "${HOME}"/Library/Jupyter/runtime/*.json
    }
fi

##########################################################
# kernelspec
##########################################################

alias jrk="jupyter kernelspec"
alias jrkls="jupyter kernelspec list"
alias jrkis="jupyter kernelspec install"
alias jrkus="jupyter kernelspec remove"

##########################################################
# book
##########################################################

alias jrb="jupyter-book"
alias jrbcr="jupyter-book create"
alias jrbcl="jupyter-book clean"
alias jrbb="jupyter-book build"

export PYDEVD_DISABLE_FILE_VALIDATION=1
