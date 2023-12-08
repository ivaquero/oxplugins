#!/bin/bash /bin/zsh
##########################################################
# text
##########################################################

pdls() {
    printf 'input-formats\n'
    pandoc --list-input-formats
    printf 'output-formats\n'
    pandoc --list-output-formats
}

[ -z "$OX_FONT" ] || export OX_FONT="Arial Unicode MS"

# change font
chft() {
    export OX_FONT=$1
}

##########################################################
# markdown
##########################################################

# $1: input file, $2: output format
mdto() {
    if [[ "$1" == "pdf" ]]; then
        if test "$(command -v tectonic)"; then
            pdf_engine=tectonic
        elif test "$(command -v xelatex)"; then
            pdf_engine=xelatex
        else
            echo "No available pdf engine found"
        fi
        pandoc "$2" -o "${2%%.*}"."$1" --pdf-engine="$pdf_engine" -V CJKmainfont="${OX_FONT}"
    elif [[ "$1" == "html" ]]; then
        pandoc "$2" -o "${2%%.*}"."$1" --standalone --mathjax --shift-heading-level-by=-1
    else
        pandoc "$2" -o "${2%%.*}"."$1"
    fi
}

##########################################################
# pdf
##########################################################

##########################################################
# audio
##########################################################

tomp3() {
    if [[ -z "$2" ]]; then
        cbr=192K
    else
        cbr=$2K
    fi
    ffmpeg -i "$1" -c:a libmp3lame -b:a "$cbr" "${1%%.*}".mp3
}
