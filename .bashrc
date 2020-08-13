#!/bin/bash
# shellcheck disable=SC1090
shopt -s histappend             # append to history instead of overwrite
shopt -s cmdhist                # save multiline cmds in history
shopt -s cdspell                # spellcheck cd
shopt -s extglob                # bash extended globbing
set -o noclobber                # no clobber of files on redirect >| override
set -o vi                       # use a vi-style command line editing interface

export LC_ALL="en_US.UTF-8"
export LANG="en_US"

export CLICOLOR=1               # colorize ls
export LSCOLORS=fxfxcxdxbxegedabagacad
export LESS='-X -R -M --shift 5' # LESS no clear on exit, show RAW ANSI, long prompt, move 5 on arrow
export EDITOR=vim               # vim is the only editor
export VISUAL=vim               # vim is the only editor

export HISTCONTROL=ignoreboth   # skip space cmds and dupes in history
export HISTIGNORE="ls:ls -la:cd:cd -:pwd:exit:date:* --help:fg:bg:history:w"
export HISTFILE=$HOME/.bash_history
export HISTSIZE=9000
export HISTFILESIZE=${HISTSIZE}
export HISTTIMEFORMAT="%F %T: "
export HISTCONTROL=ignorespace:erasedups
export DBHISTORY=true
export DBHISTORYFILE=$HOME/.dbhist

history() {
  _bash_history_sync
  builtin history "$@"
}

_bash_history_sync() {
  builtin history -a
  HISTFILESIZE=$HISTSIZE
  builtin history -c
  builtin history -r
}
export starship_precmd_user_func=_bash_history_sync

# hex to decimal and vice-versa
h2d() { echo $((16#$@)); }
d2h() { echo $((0x$@)); }

alias idle='while true ; do uname -a ; uptime ; sleep 30 ; done'
alias ipsort='sort  -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4'
alias j='jobs -l'
alias sl=ls
alias today='date +"%A, %B %d, %Y"'
alias yesterday='date -v-1d +"%A %B %d, %Y"'
alias epoch='date +%s'
alias rot13='tr a-zA-Z n-za-mN-ZA-M'
alias badge="tput bel"

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

#function autoCompleteHostname() {
#    local hosts
#    local cur
#    hosts=($(awk '{print $1}' ~/.ssh/known_hosts | cut -d, -f1))
#    cur=${COMP_WORDS[COMP_CWORD]}
#    COMPREPLY=($(compgen -W '${hosts[@]}' -- $cur ))
#}
#complete -F autoCompleteHostname ssh # ssh autocomplete function

function repeat () {
    local count="$1" i
    shift
    for i in $(seq 1 "$count"); do
        eval "$@"
    done
}

function seqx () {
    local lower upper output
    lower=$1 upper=$2
    while [ "$lower" -le "$upper" ]; do
        output="$output $lower"
        lower=$(( "$lower" + 1 ))
    done
    echo "$output"
}

function ip2hex () {
    local ip="$1"
    echo "$ip" |
    awk -F. '{ for ( i=1; i<=NF; ++i ) printf ("%02x", $i % 256); print "" }'
}

function spinner () {
    i=1
    sp="/-\|"
    echo -n ' '
    while true ; do
        echo -en "\b${sp:i++%${#sp}:1}"
    done
}

function ssh-copy-id {
    if [[ -z "$1" ]]; then
        echo "!! You need to enter a hostname in order to send your public key !!"
    else
        echo "* Copying SSH public key to server..."
        ssh "${1}" "mkdir -p .ssh && cat - >> .ssh/authorized_keys" < ~/.ssh/id_ed25519.pub
        echo "* All done!"
    fi

    ID_FILE="${HOME}/.ssh/id_ed25519.pub"

    if [ "-i" = "$1" ]; then
        shift
        # check if we have 2 parameters left, if so the first is the new ID file
        if [ -n "$2" ]; then
            if expr "$1" : ".*\.pub" > /dev/null ; then
                ID_FILE="$1"
            else
                ID_FILE="$1.pub"
            fi
            shift         # and this should leave $1 as the target name
        fi
    else
        if [ "x$SSH_AUTH_SOCK" != x ] && ssh-add -L >/dev/null 2>&1; then
            GET_ID="$GET_ID ssh-add -L"
        fi
    fi

    if [ -z "$(eval "$GET_ID")" ] && [ -r "${ID_FILE}" ] ; then
        GET_ID="cat ${ID_FILE}"
    fi

    if [ -z "$(eval "$GET_ID")" ]; then
        echo "ssh-copy-id: ERROR: No identities found" >&2
        return 1
    fi

    if [ "$#" -lt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: ssh-copy-id [-i [identity_file]] [user@]machine" >&2
        return 1
    fi

    # strip any trailing colon
    host=${1%:}

    { eval "$GET_ID" ; } | ssh "$host" "umask 077; test -d ~/.ssh || mkdir ~/.ssh ; cat >> ~/.ssh/authorized_keys" || return 1

    cat <<EOF
Now try logging into the machine, with "ssh '$host'", and check in:

    ~/.ssh/authorized_keys

to make sure we haven't added extra keys that you weren't expecting.

EOF
}

function ip2origin() {
    if [[ -z "$1" ]]; then
        echo "Usage: $0 IP"
    else
        ipary=("${1//./ }")
        dig +short "${ipary[3]}"."${ipary[2]}"."${ipary[1]}"."${ipary[0]}".origin.asn.cymru.com TXT
    fi
}

function ip2peer() {
    if [[ -z "$1" ]]; then
        echo "Usage: $0 IP"
    else
        ipary=("${1//./ }")
        dig +short "${ipary[3]}"."${ipary[2]}"."${ipary[1]}"."${ipary[0]}".peer.asn.cymru.com TXT
    fi
}

function asninfo() {
    if [[ -z "$1" ]]; then
        echo "Usage: $0 AS#####"
    else
        dig +short "$1.asn.cymru.com" TXT
    fi
}

function surootx() {
    xauth list | while read -r XAUTH ; do
        echo "add $XAUTH" | sudo xauth
        done
        sudo -i
    }

#function httpget () {
#  IFS=/ read -r proto z host query <<< "$1"
#  exec 3< /dev/tcp/"$host"/80
#  {
#    echo GET /"$query" HTTP/1.1
#    echo connection: close
#    echo host: "$host"
#    echo
#  } >&3
#  sed '1,/^$/d' <&3 > $(basename $1)
#}

function httpcompression() {
    local encoding
    encoding="$(curl -LIs -H 'User-Agent: Mozilla/5 Gecko' -H 'Accept-Encoding: gzip,deflate,compress,sdch' "$1" |
    grep '^Content-Encoding:')" &&
    echo "$1 is encoded using ${encoding#* }" ||
    echo "$1 is not using any encoding"
}

function dataurl() {
    local mimeType
    mimeType="$(file -b --mime-type "$1")"
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

function base64url {
    base64 -w 0 | tr '+/' '-_' | tr -d '='
}

function 64font() {
    openssl base64 -in "$1" | awk -v ext="${1#*.}" '{ str1=str1 $0 }END{ print "src:url(\"data:font/"ext";base64,"str1"\")  format(\"woff\");" }'|pbcopy
    echo "$1 encoded as font and copied to clipboard"
}

function gz() {
    echo "orig size (bytes): "
    wc -c "$1"
    echo "gzipped size (bytes): "
    gzip -c "$1" | wc -c
}

function digga() {
    dig +nocmd "$1" any +multiline +noall +answer
}

function genpass() {
    local length=${1-8}
    if command -v openssl > /dev/null ; then
        openssl rand -base64 "$length" | cut -c "1-$length"
    else
        local MATRIX="HpZldxsG47f0W9gNaLRTQjhUwnvPtD5eAzr6k@EyumB3@K^cbOCV+SFJoYi2q@MIX81"
        local PASS=""
        local n=1
        while [ ${n} -le "$length" ]; do
            PASS="$PASS${MATRIX:$((RANDOM%${#MATRIX})):1}"
            n=$((n + 1))
        done
        echo $PASS
    fi
}

function highlight() {
	declare -A fg_color_map
	fg_color_map[black]=30
	fg_color_map[red]=31
	fg_color_map[green]=32
	fg_color_map[yellow]=33
	fg_color_map[blue]=34
	fg_color_map[magenta]=35
	fg_color_map[cyan]=36
	fg_color_map[white]=37

	fg_c=$(echo -e "\e[1;${fg_color_map[$1]}m")
	c_rs=$'\e[0m'
	gsed -u s"/$2/$fg_c\0$c_rs/g"
}

function tcpknock() {
  if [[ -z $1 || -z $2 ]] ; then
    echo "Usage: $0 <host> <port>"
    return
  fi
  local host=$1
  local port=$2
  timeout 1 bash -c "</dev/tcp/$host/$port &> /dev/null" &&
    echo "$host: port $port is open" ||
    echo "$host: port $port is closed"
}

function tlsdates() {
  if [[ -z $1 || -z $2 ]] ; then
    echo "Usage: $0 <host> <port>"
    return
  fi
  local host=$1
  local port=$2
  echo | openssl s_client -servername "${host}" -connect "${host}:${port}" 2>/dev/null | openssl x509 -noout -dates
}


# Platform Specific Aliases here
case $OSTYPE in
    darwin*)
        alias eject='hdiutil eject'
        alias apinfo='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I'
        alias wifi='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s'
        alias cpwd='pwd|xargs echo -n|pbcopy'
        alias flushdns='dscacheutil -flushcache'
        alias locate='mdfind -name'
        alias preview='open -a Preview'
        alias xcode='open -a Xcode'
        alias filemerge='open -a FileMerge'
        alias safari='open -a Safari'
        alias firefox='open -a Firefox'
        alias chrome='open -a "Google Chrome"'
        alias finder='open -a Finder '
        alias textedit='open -a TextEdit'
        alias hex='open -a "Hex Fiend"'
        alias ldd='otool -L'
        # homebrew
	alias yum='brew'
        alias bup='brew update && brew upgrade'
        alias bout='brew outdated'
        alias bin='brew install'
        alias brm='brew uninstall'
        alias bls='brew list'
        alias bsr='brew search'
        alias binf='brew info'
        alias bdr='brew doctor'
        alias brewski='brew update && brew upgrade && brew cask upgrade && brew cleanup; brew doctor'
        alias md5sum='md5'
        alias sha1sum='shasum'
        alias cpwd='pwd|tr -d "\n"|pbcopy'
        function f() { open -a "Finder" "${1-.}"; }
        complete -o default -o nospace -F _git g
        function pdfman () {
            man -t "$1" | open -a /Applications/Preview.app -f
        }
        function note() {
            local text
            if [ -t 0 ]; then # argument
                    text="$1"
            else # pipe
                text=$(cat)
            fi
            body=$(echo "$text" | sed -E 's|$|<br>|g')
            osascript >/dev/null <<EOF
            tell application "Notes"
                tell account "iCloud"
                    tell folder "Notes"
                        make new note with properties {name:"$text", body:"$body"}
                    end tell
                end tell
            end tell
EOF
        }

        # This retrieves unread email for the current user using dscl to get the gmail address and keychain to get the password
        function gmail() {
            user=$(dscl . -read "/Users/$(whoami)"|grep "EMailAddress:"|sed 's/^EMailAddress: //')
            pass=$(security find-internet-password -w -a "$user" -s "accounts.google.com")
            curl -u "$user:$pass" --silent "https://mail.google.com/mail/feed/atom"| perl -ne '
                print "Subject: $1 " if /<title>(.+?)<\/title>/ && $title++;
                print "(from $1)\n" if /<email>(.+?)<\/email>/;
                '
        }

        function remind() {
            local text
            if [ -t 0 ]; then
                text="$1" # argument
            else
                text=$(cat) # pipe
            fi
            osascript >/dev/null <<EOF
                    tell application "Reminders"
                    tell the default list
                        make new reminder with properties {name:"$text"}
                        end tell
                    end tell
EOF
            }

        ;;
    solaris*)
        export TERM=vt100
        ;;
    linux*)
        ;;
    netbsd)
        ;;
    FreeBSD)
        ;;
esac

complete -C /usr/local/bin/vault vault

#GIT_PROMPT_SHOW_UPSTREAM=1
#GIT_PROMPT_THEME=Custom
#if [ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]; then
#  __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
#  source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
#fi


if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
      tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

#PROMPT_COMMAND="_bash_history_sync;$PROMPT_COMMAND"

source "$HOME/.bashrc-${HOSTNAME%%.*}"

eval "$(starship init bash)"

alias op-signin='eval $(op signin my.1password.com)'
alias op-logout='op signout && unset OP_SESSION_example'

alias serveit='ruby -run -e httpd . -p 8000'
