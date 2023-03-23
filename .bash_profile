#!/bin/bash
[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"
eval "$(/usr/local/bin/brew shellenv)"
GPG_TTY=$(tty)
export GPG_TTY
export LANG="en_US.UTF-8"
export RUBYOPT='-W:deprecated '
export PATH=~/bin:${PATH}
source /usr/local/opt/rtx/etc/bash_completion.d/rtx
eval "$(/usr/local/bin/rtx activate bash)"
