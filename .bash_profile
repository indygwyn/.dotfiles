#!/bin/bash
# shellcheck disable=SC1090
[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"

export PATH=~/bin:${PATH}

export PATH=/usr/local/bin:${PATH} # homebrew
export PATH=/usr/local/sbin:${PATH} # homebrew

export PATH=${PATH}:/home/twh/.cargo/bin # cargo

# go stuff
export GOPATH=${HOME}/go
export PATH=${PATH}:${GOPATH}/bin

export GITHUB_URL=https://github.exacttarget.com/

# chef stuff
export CHEF_REPO=${HOME}/Cookbooks/salesforce/chef-repo/
export DATA_BAGS_PATH=${HOME}/Cookbooks/salesforce/data_bags
export DATA_BAG_SECRET_KEY_PATH=${HOME}/.chef/encrypted_data_bag_secret

export RUBYOPT='-W:no-deprecated -W:no-experimental'

command -v brew > /dev/null && export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
command -v rbenv > /dev/null && eval "$(rbenv init -)"

GPG_TTY=$(tty) ; export GPG_TTY
if [ -e /Users/twh/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/twh/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
