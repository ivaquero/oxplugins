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
# text
##########################################################

tohtml() {
    pandoc "$1" -o "${1%%.*}".html --standalone --mathjax --shift-heading-level-by=-1
}

todocx() {
    pandoc "$1" -o "${1%%.*}".docx
}

totyp() {
    pandoc "$1" -o "${1%%.*}".typ
}

topdf() {
    if test "$(command -v tectonic)"; then
        pdf_engine=tectonic
    elif test "$(command -v xelatex)"; then
        pdf_engine=xelatex
    else
        echo "No available pdf engine found"
    fi
    pandoc "$1" -o "${1%%.*}".pdf --pdf-engine="$pdf_engine" -V CJKmainfont="${OX_FONT}"
}

##########################################################
# media
##########################################################

tomp3() {
    if [[ -z "$2" ]]; then
        cbr=192K
    else
        cbr=$2K
    fi
    ffmpeg -i "$1" -c:a libmp3lame -b:a "$cbr" "${1%%.*}".mp3
}

tomp4() {
    ffmpeg -fflags +genpts -i "$1" -r 24 "${1%%.*}".mp4
}
