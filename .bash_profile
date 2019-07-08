#!/bin/bash
[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH:$HOME/bin:/Library/Application\ Support/MultiMarkdown/bin:/opt/X11/bin
export GOPATH=${HOME}/go
export PATH=${PATH}:${GOPATH}/bin

export PATH="/usr/local/opt/ruby/bin:$PATH" # Homebrew ruby
export PATH=/usr/local/lib/ruby/gems/2.6.0/bin:${PATH} # Homebrew Ruby Gems

export GITHUB_URL=https://github.exacttarget.com/

# Not using rbenv to manage my ruby
#if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

GPG_TTY=$(tty) ; export GPG_TTY
[ -f .iterm2_shell_integration.bash ] && source .iterm2_shell_integration.bash
