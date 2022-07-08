#!/bin/bash
[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"
eval "$(/usr/local/bin/brew shellenv)"
GPG_TTY=$(tty)
export GPG_TTY
export LANG="en_US.UTF-8"
export GOPATH=${HOME}/go
export PATH=~/bin:${PATH}
export PATH=${PATH}:${GOPATH}/bin
export CHEF_REPO=${HOME}/Cookbooks/salesforce/chef-repo/
export DATA_BAGS_PATH=${HOME}/Cookbooks/salesforce/data_bags
export DATA_BAG_SECRET_KEY_PATH=${HOME}/.chef/encrypted_data_bag_secret
#export RUBYOPT='-W:no-deprecated -W:no-experimental'
if command -v brew 1> /dev/null 2>&1 ; then
	OPENSSLHOME=$(brew --prefix openssl@1.1)
	export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${OPENSSLHOME}"
  	ASDFHOME=$(brew --prefix asdf)
else
  	ASDFHOME=$HOME/.asdf
fi
# shellcheck disable=SC1091
source "${ASDFHOME}/asdf.sh"
