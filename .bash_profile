#!/bin/bash
# shellcheck disable=SC1090
[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"

export PATH=~/bin:${PATH}

export PATH=/usr/local/bin:${PATH} # homebrew
export PATH=/usr/local/sbin:${PATH} # homebrew

command -v rbenv && eval "$(rbenv init -)"

# go stuff
export GOPATH=${HOME}/go
export PATH=${PATH}:${GOPATH}/bin

export GITHUB_URL=https://github.exacttarget.com/

# chef stuff
export CHEF_REPO=${HOME}/Cookbooks/salesforce/chef-repo/
export DATA_BAGS_PATH=${HOME}/Cookbooks/salesforce/data_bags
export DATA_BAG_SECRET_KEY_PATH=${HOME}/.chef/encrypted_data_bag_secret

GPG_TTY=$(tty) ; export GPG_TTY

# [ -f .iterm2_shell_integration.bash ] && source .iterm2_shell_integration.bash
