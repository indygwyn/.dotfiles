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
if command -v brew 1> /dev/null 2>&1 ; then
    OPENSSLHOME=$(brew --prefix openssl@1.1)
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${OPENSSLHOME}"
fi
READLINE_PATH=$(brew --prefix readline); export READLINE_PATH
OPENSSL_PATH=$(brew --prefix openssl); export OPENSSL_PATH
export LDFLAGS="-L$READLINE_PATH/lib -L$OPENSSL_PATH/lib"
export CPPFLAGS="-I$READLINE_PATH/include -I$OPENSSL_PATH/include"
export PKG_CONFIG_PATH="$READLINE_PATH/lib/pkgconfig:$OPENSSL_PATH/lib/pkgconfig"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$OPENSSL_PATH --enable-yjit"
export PATH=$OPENSSL_PATH/bin:$PATH
export PATH="$WASMTIME_HOME/bin:$PATH"
source /usr/local/opt/rtx/etc/bash_completion.d/rtx
eval "$(/usr/local/bin/rtx activate bash)"
