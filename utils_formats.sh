#!/bin/bash /bin/zsh
##########################################################
# main
##########################################################

pdlsi() {
    printf 'input-formats\n\n'
    pandoc --list-input-formats
}

pdlso() {
    printf 'output-formats\n\n'
    pandoc --list-output-formats
}

pdref() {
    pandoc --print-default-data-file reference.docx >custom-reference.docx
}

##########################################################
# text
##########################################################

tohtml() {
    pandoc "$1" -o "${1%%.*}".html --to html5 --standalone --mathjax --shift-heading-level-by=-1
}

tomd() {
    ext=${1##*.}
    if [[ "$ext" == "ipynb" ]]; then
        jupytext --to md "$1"
    else
        pandoc "$1" -o "${1%%.*}".md
    fi
}

totyp() {
    pandoc "$1" -o "${1%%.*}".typ
}

todocx() {
    pandoc "$1" -o "${1%%.*}".docx
}

topdf() {
    if command -v tectonic >/dev/null 2>&1; then
        pdf_engine=tectonic
    elif command -v xelatex >/dev/null 2>&1; then
        pdf_engine=xelatex
    elif command -v lualatex >/dev/null 2>&1; then
        pdf_engine=lualatex
    elif command -v pdflatex >/dev/null 2>&1; then
        pdf_engine=pdflatex
    else
        echo "No available pdf engine found"
    fi
    pandoc "$1" -o "${1%%.*}".pdf --pdf-engine="$pdf_engine" --syntax-highlighting tango \
        -V colorlinks \
        -V urlcolor=NavyBlue \
        -V geometry:a4paper \
        -V geometry:margin=2.5cm \
        -V CJKmainfont="STFangsong"

}

toipynb() {
    jupytext --to notebook "$1"
}

##########################################################
# notebook
##########################################################

py2html() {
    marimo export html "${1%%.*}".py >"${1%%.*}".html
}

ipynb2py() {
    marimo convert "${1%%.*}".ipynb >"${1%%.*}".py
}

##########################################################
# image
##########################################################

topng() {
    magick "$1" -o "${1%%.*}".png
}

tojpg() {
    magick "$1" -o "${1%%.*}".jpg
}

bgnone() {
    if [[ -z "$2" ]]; then
        bg=white
    else
        bg=$2
    fi
    magick "$1" -background "$bg" "$1"
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
