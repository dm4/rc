# tmux setup
[ -t 1 ] && [ -z "$TMUX" ] && [ -x bin/tmx ] && bin/tmx

# Path
export PATH=".:$HOME/bin/:$PATH"

# Editor
export SVN_EDITOR=vim
export EDITOR=vim

# History
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=ignoreboth

# Aliases
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias ls="ls -F --color=auto"
alias ll="ls -lh"
alias la="ll -A"
alias grep="grep --color=auto"
alias dh='df -H'
alias ptt="ssh bbsu@ptt.cc"
alias p2="ssh bbsu@ptt2.cc"
alias g="git"
alias gs="git status"
alias gd="git diff"
alias gdw="git diff --word-diff"
alias gds="git diff --staged"
alias gap="git add -p"
alias gcm="git commit -m"
alias ev="vim ~/.vimrc"
alias eb="vim ~/.bashrc"
alias et="vim ~/.tmux.conf"
alias p="perl -e 'print \$_, \"\\n\" for split /:/, \$ENV{PATH}'"
alias svndi="svn di | colordiff"
alias gl="github_link"
alias gw="github_web"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias drm="docker rm"
alias drmi="docker rmi"
alias dstop="docker stop"
alias dstart="docker start"
alias nssh="ssh -o StrictHostKeyChecking=no"
[ -n "$(which hub)" ] && alias git=hub

# perlbrew
[ -f ~/perl5/perlbrew/etc/bashrc ] && . ~/perl5/perlbrew/etc/bashrc

# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# rvm (rvm path should be at first place)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Functions

# mkdir & cd
function mkcd { mkdir -p "$@" && cd "$@"; }

function len { echo ${#1}; }

function t { date -d "+@$1"; }

function v {
    if [ -n "$*" ]; then
        vim $*
    else
        if [ -f Session.vim ]; then
            vim -S
        else
            vim
        fi
    fi
}

function ip {
    if [ -z "$1" ]; then
        if [ `uname` = 'Darwin' ]; then
            local interface='en0'
        else
            local interface='eth0'
        fi
    else
        local interface="$1"
    fi
    ifconfig "$interface" | sed -En 's/.*inet ([^ ]+).*/\1/p'
}

function drun {
    local matched_num=$(docker ps -aqf "name=$1" | wc -l | sed -En 's/.*([0-9]+).*/\1/p')
    if [ "$matched_num" = '0' ]; then
        echo "Container $1 not found."
    elif [ "$matched_num" = '1' ]; then
        local container=$(docker ps -aqf "name=$1" | head -1)
        docker start -a "$container"
    else
        echo "Which container do you wanna run?"
        echo ""
        docker ps -af "name=$1" | tail -n +2
    fi
}

function pk {
    if [ "$#" != '1' ]; then
        echo "Usage:"
        echo "    pk <ID of pwnable.kr>"
    else
        curl -sd "user=$1" http://pwnable.kr/lib.php?cmd=finduser | sed -nE 's/.*"(.*)".*/\1/p'
    fi

}

function remove_known_host {
    [ -n "$1" ] && sed -i '' "$1d" ~/.ssh/known_hosts
}

function ish {
    if [ -n "$1" ]; then
        local ip="$1"
        shift
        echo ssh "192.168.1.$ip" "$@"
        ssh -A -o StrictHostKeyChecking=no "192.168.1.$ip" "$@"
    fi
}

function yaml2json {
    [ -n "$1" ] && [ -f "$1" ] && python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < "$1"
}

# git-prompt setting
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
[ -f ~/.dotfiles/git-prompt.sh ] && source ~/.dotfiles/git-prompt.sh

# prompt setting
# [~] ➟
arrow_color="\[\e[0;31m\]"
git_prompt_color="\[\e[0;35m\]"
clear_color="\[\e[m\]"
[ $UID -eq 0 ] && arrow_color="\e[0;34m"
export PS1="${git_prompt_color}\$(__git_ps1 '(%s) ')${clear_color}[\w] ${arrow_color}➟  ${clear_color}"

# for Mac OSX
if [ `uname` = "Darwin" ]; then
    # alias
    alias ls="ls -HGF"
    alias app="open -a"
    alias mou="open -a mou"
    alias gitx="open -a gitx ."
    alias mp="open -a Marked"
    alias hide="chflags hidden ~/Desktop/*"
    alias show="chflags nohidden ~/Desktop/*"
    alias xcode="find . -name '*.xcodeproj' -exec open {} \;"
    alias subl="/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl"
    alias md="open -a Marked"
    alias lsusb="system_profiler SPUSBDataType"
    alias dm='docker-machine'
    alias dip='docker-machine ip'
    alias denv='test -x $(which docker-machine) && eval "$(docker-machine env)"'
    alias dinit='test -x $(which docker-machine) && docker-machine start && eval "$(docker-machine env)"'
    alias dssh="ssh -l root -p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \$(docker-machine ip)"
    alias lsb_release="system_profiler SPSoftwareDataType"

    # ENV variables
    export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
    export ANDROID_HOME=/usr/local/Cellar/android-sdk/r20.0.1
    export GOPATH=${HOME}/workspace/go
    export PATH=$PATH:$GOPATH/bin

    # open in finder
    function o {
        if [ -n "$*" ]; then
            open "$*"
        else
            open .
        fi
    }

    # bash completions
    [ -f `brew --prefix`/etc/bash_completion ] && . `brew --prefix`/etc/bash_completion
    [ -f `brew --prefix`/etc/bash_completion.d/vagrant ] && . `brew --prefix`/etc/bash_completion.d/vagrant

    # autojump
    [ -f `brew --prefix`/etc/autojump.sh ] && . `brew --prefix`/etc/autojump.sh

    # grc
    [ -f `brew --prefix grc`/etc/grc.bashrc ] && . `brew --prefix grc`/etc/grc.bashrc

    # nvm
    [ -f `brew --prefix nvm`/nvm.sh ] && . `brew --prefix nvm`/nvm.sh
else
    # aotujump
    [ -f /usr/share/autojump/autojump.bash ] && . /usr/share/autojump/autojump.bash

    # nvm
    [ -s ~/.nvm/nvm.sh ] && . ~/.nvm/nvm.sh
fi

if [ $TERM = "xterm-256color" ]; then
    # colorful man page
    export PAGER="`which less` -s"
    export BROWSER="$PAGER"
    export LESS_TERMCAP_mb=$'\E[38;5;167m' # begin blinking
    export LESS_TERMCAP_md=$'\E[38;5;39m' # begin bold
    export LESS_TERMCAP_me=$'\E[0m' # end mode
    export LESS_TERMCAP_se=$'\E[38;5;231m' # end standout-mode
    export LESS_TERMCAP_so=$'\E[38;5;167m' # begin standout-mode - info box
    export LESS_TERMCAP_us=$'\E[38;5;167m' # begin underline
    export LESS_TERMCAP_ue=$'\E[0m' # end underline
    export LESS_TERMCAP_uz=$'\E[0m' # just for export looking by dm4
fi
