#!/bin/bash
export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH=~/bin:/opt/homebrew/bin:/usr/local/bin:${PATH}
BREW_PREFIX=$(brew --prefix) ; export BREW_PREFIX
eval "$(${BREW_PREFIX}/bin/brew shellenv)"
GPG_TTY=$(tty)
export GPG_TTY
export LANG="en_US.UTF-8"
export RUBYOPT='-W:deprecated '
export PYTHONSTARTUP="${HOME}/.config/python/startup.py"
# shellcheck source=/dev/null
source "${BREW_PREFIX}/opt/rtx/etc/bash_completion.d/rtx"
eval "$(${BREW_PREFIX}/bin/rtx activate bash)"
source "${HOME}/.bashrc"
