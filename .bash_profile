#!/bin/bash
# shellcheck disable=SC1090
[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"

export PATH=~/bin:${PATH}

export PATH=/usr/local/bin:${PATH} # homebrew
export PATH=/usr/local/sbin:${PATH} # homebrew
export PATH=/usr/local/opt/openssl@1.1/bin:${PATH}
export PATH="$HOME/.tfenv/bin:$PATH"


export PATH=${PATH}:/home/twh/.cargo/bin # cargo

export LANG="en_US.UTF-8"

# go stuff
export GOPATH=${HOME}/go
export PATH=${PATH}:${GOPATH}/bin

export GITHUB_URL=https://github.exacttarget.com/

# chef stuff
export CHEF_REPO=${HOME}/Cookbooks/salesforce/chef-repo/
export DATA_BAGS_PATH=${HOME}/Cookbooks/salesforce/data_bags
export DATA_BAG_SECRET_KEY_PATH=${HOME}/.chef/encrypted_data_bag_secret

export RUBYOPT='-W:no-deprecated -W:no-experimental'
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

command -v brew 1> /dev/null 2>&1 && export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
command -v rbenv 1> /dev/null 2>&1 && eval "$(rbenv init -)"
command -v pyenv 1>/dev/null 2>&1 && eval "$(pyenv init -)"

GPG_TTY=$(tty) ; export GPG_TTY
