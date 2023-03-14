#!/bin/bash
# uncomment the folowing and last 2 lines to profile startup
# PS4='+ $EPOCHREALTIME\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log
# set -x

shopt -s histappend # append to history instead of overwrite
shopt -s cmdhist    # save multiline cmds in history
shopt -s cdspell    # spellcheck cd
shopt -s extglob    # bash extended globbing
set -o noclobber    # no clobber of files on redirect >| override
set -o vi           # use a vi-style command line editing interface

export LC_ALL="en_US.UTF-8"
export LANG="en_US"
export CLICOLOR=1 # colorize ls
export LSCOLORS=Exfxcxdxbxegedabagacad
#export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
LS_COLORS="$(vivid generate dracula)"
export LS_COLORS
export LESS='-X -R -M --shift 5' # LESS no clear on exit, show RAW ANSI, long prompt, move 5 on arrow
export EDITOR=vim                # vim is the only editor
export VISUAL=vim                # vim is the only editor
export HISTCONTROL=ignoreboth    # skip space cmds and dupes in history
export HISTIGNORE="ls:ls -la:cd:cd -:pwd:exit:date:* --help:fg:bg:history:w"
export HISTFILE="$HOME/.bash_history"
export HISTFILESIZE=1000000
export HISTSIZE=${HISTFILESIZE}
export HISTTIMEFORMAT="%F %T: "
export HISTCONTROL=ignorespace:erasedups
export DBHISTORY=true
export DBHISTORYFILE="$HOME/.dbhist"
export starship_precmd_user_func=_bash_history_sync
export CDPATH=.:"$HOME"

function history {
    _bash_history_sync
    builtin history "$@"
}

function _bash_history_sync {
    builtin history -a
    HISTFILESIZE=$HISTSIZE
    builtin history -c
    builtin history -r
}

# hex to decimal and vice-versa
function h2d {
    echo $((16#$@))
}
function d2h {
    echo $((0x$@))
}

function autoCompleteHostname {
    local hosts
    local cur
    # shellcheck disable=SC2034,SC2207
    hosts=($(awk '{split($1,a,",");print a[1]}' "$HOME/.ssh/known_hosts"))
    cur=${COMP_WORDS[COMP_CWORD]}
    # shellcheck disable=SC2016,SC2207,SC2086
    COMPREPLY=($(compgen -W '${hosts[@]}' -- $cur))
}
complete -F autoCompleteHostname ssh # ssh autocomplete function

function cd {
    case $1 in
    ....)
        builtin cd ../../.. || return
        ;;
    ...)
        builtin cd ../.. || return
        ;;
    *)
        builtin cd "$@" || return
        ;;
    esac
}

function seqx {
    local lower upper output
    lower=$1 upper=$2
    while [ "$lower" -le "$upper" ]; do
        output="$output $lower"
        lower=$(("$lower" + 1))
    done
    echo "$output"
}

function ip2hex {
    local ip="$1"
    echo "$ip" |
        awk -F. \
            '{ for ( i=1; i<=NF; ++i ) printf ("%02x", $i % 256); print "" }'
}

function spinner {
    i=1
    sp="/-\|"
    echo -n ' '
    while true; do
        echo -en "\b${sp:i++%${#sp}:1}"
    done
}

function ssh-copy-id {
    if [[ -z "$1" ]]; then
        echo "!! Enter a hostname in order to send public key !!"
    else
        echo "* Copying SSH public key to server..."
        ssh "${1}" "mkdir -p .ssh && cat - >> .ssh/authorized_keys" <"\
$HOME/.ssh/id_ed25519.pub"
        echo "* All done!"
    fi

    ID_FILE="${HOME}/.ssh/id_ed25519.pub"

    if [ "-i" = "$1" ]; then
        shift
        # check if we have 2 parameters left, if so the first is the new ID file
        if [ -n "$2" ]; then
            if expr "$1" : ".*\.pub" >/dev/null; then
                ID_FILE="$1"
            else
                ID_FILE="$1.pub"
            fi
            shift # and this should leave $1 as the target name
        fi
    else
        if [ "x$SSH_AUTH_SOCK" != x ] && ssh-add -L >/dev/null 2>&1; then
            GET_ID="$GET_ID ssh-add -L"
        fi
    fi

    if [ -z "$(eval "$GET_ID")" ] && [ -r "${ID_FILE}" ]; then
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

    { eval "$GET_ID"; } | ssh "$host" "umask 077; test -d \${HOME}/.ssh || mkdir \${HOME}/.ssh ; cat >> \${HOME}/.ssh/authorized_keys" || return 1

    cat <<EOF
Now try logging into the machine, with "ssh '$host'", and check in:

    ${HOME}/.ssh/authorized_keys

to make sure we haven't added extra keys that you weren't expecting.

EOF
}

function ip2origin {
    if [[ -z "$1" ]]; then
        echo "Usage: $0 IP"
    else
        ipary=("${1//./ }")
        dig +short "${ipary[3]}"."${ipary[2]}"."${ipary[1]}"."${ipary[0]}".origin.asn.cymru.com TXT
    fi
}

function ip2peer {
    if [[ -z "$1" ]]; then
        echo "Usage: $0 IP"
    else
        ipary=("${1//./ }")
        dig +short "${ipary[3]}"."${ipary[2]}"."${ipary[1]}"."${ipary[0]}".peer.asn.cymru.com TXT
    fi
}

function asninfo {
    if [[ -z "$1" ]]; then
        echo "Usage: $0 AS#####"
    else
        dig +short "$1.asn.cymru.com" TXT
    fi
}

function surootx {
    xauth list | while read -r XAUTH; do
        echo "add $XAUTH" | sudo xauth
    done
    sudo -i
}

function httpget {
    # shellcheck disable=SC2034
    IFS=/ read -r proto z host query <<<"$1"
    exec 3</dev/tcp/"$host"/80
    {
        echo GET /"$query" HTTP/1.1
        echo connection: close
        echo host: "$host"
        echo
    } >&3
    sed '1,/^$/d' <&3 >"$(basename "$1")"
}

function httpcompression {
    local encoding
    encoding="$(curl -LIs -H 'User-Agent: Mozilla/5 Gecko' -H 'Accept-Encoding: gzip,deflate,compress,sdch' "$1" |
        grep '^Content-Encoding:')" &&
        echo "$1 is encoded using ${encoding#* }" ||
        echo "$1 is not using any encoding"
}

function dataurl {
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

function 64font {
    openssl base64 -in "$1" | awk -v ext="${1#*.}" '{ str1=str1 $0 }END{ print "src:url(\"data:font/"ext";base64,"str1"\")  format(\"woff\");" }' | pbcopy
    echo "$1 encoded as font and copied to clipboard"
}

function gz {
    echo "orig size (bytes): "
    wc -c "$1"
    echo "gzipped size (bytes): "
    gzip -c "$1" | wc -c
}

function digga {
    dig +nocmd "$1" any +multiline +noall +answer
}

function genpass {
    local length=${1-8}
    if command -v openssl >/dev/null; then
        openssl rand -base64 "$length" | cut -c "1-$length"
    else
        local MATRIX="HpZldxsG47f0W9gNaLRTQjhUwnvPtD5eAzr6k@EyumB3@K^cbOCV+SFJoYi2q@MIX81"
        local PASS=""
        local n=1
        while [ ${n} -le "$length" ]; do
            PASS="$PASS${MATRIX:$((RANDOM % ${#MATRIX})):1}"
            n=$((n + 1))
        done
        echo $PASS
    fi
}

function highlight {
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

function tcpknock {
    if [[ -z $1 || -z $2 ]]; then
        echo "Usage: $0 <host> <port>"
        return
    fi
    local host=$1
    local port=$2
    timeout 1 bash -c "</dev/tcp/$host/$port &> /dev/null" &&
        echo "$host: port $port is open" ||
        echo "$host: port $port is closed"
}

function tlsdates {
    if [[ -z $1 || -z $2 ]]; then
        echo "Usage: $0 <host> <port>"
        return
    fi
    local host=$1
    local port=$2
    echo | openssl s_client -servername "${host}" -connect "${host}:${port}" 2>/dev/null | openssl x509 -noout -dates
}

function truecolor {
    printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"
}

function is_in_git_repo {
    git rev-parse HEAD >/dev/null 2>&1
}

function fzf-down {
    fzf --height 50% --min-height 20 --border --bind ctrl-/:toggle-preview "$@"
}

function _gf {
    is_in_git_repo || return
    git -c color.status=always status --short |
        fzf-down -m --ansi --nth 2..,.. \
            --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
        cut -c4- | sed 's/.* -> //'
}

function _gb {
    is_in_git_repo || return
    git branch -a --color=always | grep -v '/HEAD\s' | sort |
        fzf-down --ansi --multi --tac --preview-window right:70% \
            --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
        sed 's/^..//' | cut -d' ' -f1 |
        sed 's#^remotes/##'
}

function _gt {
    is_in_git_repo || return
    git tag --sort -version:refname |
        fzf-down --multi --preview-window right:70% \
            --preview 'git show --color=always {}'
}

function _gh {
    is_in_git_repo || return
    git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
        fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
            --header 'Press CTRL-S to toggle sort' \
            --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
        grep -o "[a-f0-9]\{7,\}"
}

function _gr {
    is_in_git_repo || return
    git remote -v | awk '{print $1 "\t" $2}' | uniq |
        fzf-down --tac --preview \
            'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
        cut -d$'\t' -f1
}

function _gs {
    is_in_git_repo || return
    git stash list | fzf-down --reverse -d: --preview \
        'git show --color=always {1}' |
        cut -d: -f1
}

function git2http {
    if [[ -n "$1" ]]; then
        echo "Read from positional argument $1"
        echo "$1" | sed -e 's/\:/\//' -e 's/git@/https:\/\//'
        return
    elif [[ ! -t 0 ]]; then
        echo "Read from stdin if file descriptor /dev/stdin is open"
        cat </dev/stdin | sed -e 's/\:/\//g' -e 's/git@/https:\/\//g'
    else
        echo "No standard input."
        echo "Usage: $0 git@somegithost:Path/Repo.git"
        return
    fi
    echo
    return
}

if [[ $- =~ i ]]; then
    bind '"\er": redraw-current-line'
    bind '"\C-g\C-f": "$(_gf)\e\C-e\er"'
    bind '"\C-g\C-b": "$(_gb)\e\C-e\er"'
    bind '"\C-g\C-t": "$(_gt)\e\C-e\er"'
    bind '"\C-g\C-h": "$(_gh)\e\C-e\er"'
    bind '"\C-g\C-r": "$(_gr)\e\C-e\er"'
    bind '"\C-g\C-s": "$(_gs)\e\C-e\er"'
fi

# Platform Specific Aliases here
case $OSTYPE in
darwin*)
    alias ls="gls --color"
    alias eject='hdiutil eject'
    alias apinfo='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I'
    alias wifi='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s'
    alias cpwd='pwd|xargs echo -n|pbcopy'
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
    alias md5sum='md5'
    alias sha1sum='shasum'
    alias cpwd='pwd|tr -d "\n"|pbcopy'
    #alias docker='podman'
    function flushdns {
        sudo dscacheutil -flushcache
        sudo killall -HUP mDNSResponder
    }
    function brew-up {
        brew update && brew upgrade && brew cleanup
    }
    function rtx-up {
        rtx self-update
        rtx plugins update --all
    }
    function vim-up {
        vim +PlugUpgrade +PlugUpdate +PlugClean +qall
    }
    function f { open -a "Finder" "${1-.}"; }
    complete -o default -o nospace -F _git g
    function pdfman() {
        mandoc -T pdf "$(/usr/bin/man -w "$@")" | open -fa Preview
    }
    function note {
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

    function remind {
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
esac

complete -C vault vault

alias idle='while true ; do uname -a ; uptime ; sleep 30 ; done'
alias ipsort='sort  -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4'
alias j='jobs -l'
alias sl=ls
alias today='date +"%A, %B %d, %Y"'
alias yesterday='date -v-1d +"%A %B %d, %Y"'
alias epoch='date +%s'
alias rot13='tr a-zA-Z n-za-mN-ZA-M'
alias badge="tput bel"
alias op-signin='eval $(op signin my.1password.com)'
alias op-logout='op signout && unset OP_SESSION_example'
alias serveit='ruby -run -e httpd . -p 8000'
alias dotfiles='git --git-dir="${HOME}/.dotfiles/" --work-tree="${HOME}"'
alias dtig='GIT_DIR="${HOME}/.dotfiles" GIT_WORK_TREE="${HOME}" tig'
export EXA_COLORS="da=1;34:di=32:gm=33:gd=31"
export EXA_STRICT=true
alias x='exa --all --long --header --group --group-directories-first --time-style long-iso --git --git-ignore'
alias x1='exa --oneline --all --group-directories-first'
alias xt='exa --tree'
alias vim-update='vim +PlugUpgrade +PlugUpdate +PlugClean +qall!'
alias j2y='jq -r toYaml'
alias asdf=rtx
eval "$(rtx exec starship -- starship init bash)"
eval "$(rtx exec direnv -- direnv hook bash)"
# eval "$(navi widget bash)"
#[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# shellcheck source=/dev/null
[ -f ~/.bashrc-local ] && source ~/.bashrc-local
# shellcheck source=/dev/null
[ -f ~/.bash.d/cht.sh ] && source ~/.bash.d/cht.sh
bind -f ~/share/bash-surround/inputrc-surround
# shellcheck source=/dev/null
source ~/.config/op/plugins.sh
