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
source "${BREW_PREFIX}/opt/mise/etc/bash_completion.d/mise"
eval "$(${BREW_PREFIX}/bin/mise activate bash)"
source "${HOME}/.bashrc"

# Created by `pipx` on 2024-10-09 13:25:43
export PATH="$PATH:/Users/tholt/.local/bin"


# devbar-managed-start
export NODE_EXTRA_CA_CERTS="$HOME/.devbar/certs/corporate-ca-bundle.pem"
# devbar-managed-end

# >>> aisuite >>>
export NODE_EXTRA_CA_CERTS="/Users/tholt/.aisuite/conf/npm-sfdc-certs.pem"
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) [ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH" ;;
esac
export PATH="/Users/tholt/.aisuite/bin:/Users/tholt/.aisuite/bin/aliases:$PATH"
# <<< aisuite <<<

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/tholt/.lmstudio/bin"
# End of LM Studio CLI section

