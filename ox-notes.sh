#!/bin/bash /bin/zsh
##########################################################
# obsidian
##########################################################

OX_OXIDE[bkob]=${OX_BACKUP}/obsidian/community-plugins.json
OX_OXIDE[bkob_]=${OX_BACKUP}/obsidian/plugins
OX_ELEMENT[ob]=${OX_OXIDIAN}/.obsidian/community-plugins.json
OX_ELEMENT[ob_]=${OX_OXIDIAN}/.obsidian/plugins

##########################################################
# logseq
##########################################################

OX_OXIDE[bklg]=${OX_BACKUP}/logseq/config/config.edn
OX_OXIDE[bklgx]=${OX_BACKUP}/logseq/config/plugins.edn
OX_OXIDE[bklgx_]=${OX_BACKUP}/logseq/plugins

OX_ELEMENT[lg]=${HOME}/.logseq/config/config.edn
OX_ELEMENT[lgx]=${HOME}/.logseq/config/plugins.edn
OX_ELEMENT[lgx_]=${HOME}/.logseq/plugins

##########################################################
# typst
##########################################################

# compile typst
typall() {
    for file in "${OX_TYPST_ROOT}"/"$1"/*.typ; do typst c "$file"; done
}

export TYPST_PACKAGES="${APPDATA}/typst"
