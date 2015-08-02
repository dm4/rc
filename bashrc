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

# aotujump
[ -f /usr/share/autojump/autojump.bash ] && . /usr/share/autojump/autojump.bash

# perlbrew
[ -f ~/perl5/perlbrew/etc/bashrc ] && . ~/perl5/perlbrew/etc/bashrc

# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# nvm
[ -s ~/.nvm/nvm.sh ] && . ~/.nvm/nvm.sh

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

function ssh-copy-id {
    if [ "$#" != '1' ]; then
        echo "Usage:"
        echo "    ssh-copy-id user@host"
    else
        cat ~/.ssh/id_rsa.pub | ssh "$1" 'mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys'
    fi
}

function git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
    echo "("${ref#refs/heads/}") ";
}

function github_link {
    remote=$(git remote -v 2>/dev/null) || return;
    echo "$remote" | sed 's|git@github.com:|https://github.com/|' | sed -nE 's|.*(http[^ ]*).*|\1|p' | sort -u
}

function github_web {
    local url=$(github_link | head -1)
    open "$url"
}

# prompt setting
# [~] ➟
arrow_color="\e[0;31m"
[ $UID -eq 0 ] && arrow_color="\e[0;34m"
export PS1="\[\e[0;35m\]\$(git_branch)\[\e[m\][\w] \[${arrow_color}\]➟  \[\e[m\]"

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
    alias dinit='test -x $(which boot2docker) && boot2docker up && eval "$(boot2docker shellinit)"'
    alias dssh="ssh -l root -p 2222 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \$(boot2docker ip 2>&1 | grep 'IP address is' | sed -En 's/.* is: ([0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+).*/\\1/p')"
    alias lsb_release="system_profiler SPSoftwareDataType"

    # ENV variables
    export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
    export ANDROID_HOME=/usr/local/Cellar/android-sdk/r20.0.1
    export GOPATH=${HOME}/workspace/go
    export PATH=$PATH:$GOPATH/bin

    # to solve OSX Lion update_terminal_cwd bug
#    . /etc/bashrc

    # open in finder
    function o {
        if [ -n "$*" ]; then
            open "$*"
        else
            open .
        fi
    }

    # macvim
    function svim {
        if [ -n "$*" ]; then
            if [ "$(mvim --serverlist)" = 'VIM-SERVER' ]; then
                mvim --servername VIM-SERVER --remote-tab $*
            else
                mvim --servername VIM-SERVER $*
            fi
        else
            mvim --servername VIM-SERVER
        fi
    }

    # bash completion
    [ -f `brew --prefix`/etc/bash_completion ] && . `brew --prefix`/etc/bash_completion

    # autojump
    [ -f `brew --prefix`/etc/autojump.sh ] && . `brew --prefix`/etc/autojump.sh

    # grc
    [ -f `brew --prefix grc`/etc/grc.bashrc ] && . `brew --prefix grc`/etc/grc.bashrc
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
