#!/bin/bash
# shellcheck disable=SC1090
[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"

export LANG="en_US.UTF-8"
export PYENV_ROOT="$HOME/.pyenv"

export PATH=~/bin:${PATH}
export PATH=/usr/local/bin:${PATH}       # homebrew
export PATH=/usr/local/sbin:${PATH}      # homebrew
export PATH=/usr/local/opt/openssl@1.1/bin:${PATH}

export PATH="$HOME/.tfenv/bin:$PATH"     # tfenv
export PATH="$PYENV_ROOT/bin:$PATH"      # pyenv
export PATH=${PATH}:/home/twh/.cargo/bin # cargo


export GOPATH=${HOME}/go
export PATH=${PATH}:${GOPATH}/bin

export GITHUB_URL=https://github.exacttarget.com/

# chef stuff
export CHEF_REPO=${HOME}/Cookbooks/salesforce/chef-repo/
export DATA_BAGS_PATH=${HOME}/Cookbooks/salesforce/data_bags
export DATA_BAG_SECRET_KEY_PATH=${HOME}/.chef/encrypted_data_bag_secret

export RUBYOPT='-W:no-deprecated -W:no-experimental'

if command -v brew 1> /dev/null 2>&1 ; then
	OPENSSLHOME=$(brew --prefix openssl@1.1)
	# shellcheck disable=SC2155
	export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${OPENSSLHOME}"
  	ASDFHOME=$(brew --prefix asdf)
else
  	ASDFHOME=$HOME/.asdf

fi
# shellcheck disable=SC1091
source "${ASDFHOME}/asdf.sh"

GPG_TTY=$(tty) ; export GPG_TTY
