#!/bin/bash
function path_prepend { [[ -d $1 ]] && PATH="$1:$PATH"; }
function path_append { [[ -d $1 ]] && PATH="$PATH:$1"; }
function path_dedupe {
    local IFS=: dir new=
    for dir in $PATH; do
        [[ :$new: == *:"$dir":* ]] || new=${new:+$new:}$dir
    done
    PATH=$new
}

for prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
    if [[ -x $prefix/bin/brew ]]; then
        eval "$("$prefix/bin/brew" shellenv)"
        break
    fi
done
unset prefix

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

export BASH_SILENCE_DEPRECATION_WARNING=1
export LANG="en_US.UTF-8"
export EDITOR=vim
export VISUAL=vim
export LESS='-X -R -M --shift 5'
export RUBYOPT='-W:deprecated '
export PYTHONSTARTUP="${HOME}/.config/python/startup.py"
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad
export EXA_COLORS="da=1;34:di=32:gm=33:gd=31"
export EXA_STRICT=true

# shellcheck source=/dev/null
[[ -f ~/.bash_profile-local ]] && source ~/.bash_profile-local

path_dedupe
export PATH

command -v mise >/dev/null && eval "$(mise activate bash --shims)"
command -v vivid >/dev/null && LS_COLORS="$(vivid generate dracula)" && export LS_COLORS

# shellcheck source=/dev/null
[[ -f ~/.bashrc ]] && source ~/.bashrc
