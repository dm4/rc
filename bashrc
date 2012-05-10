# update PATH
PATH="/usr/local/sbin:$(perl -e 'print join ":", grep { $_ ne "/usr/local/sbin" } split/:/, $ENV{PATH};')"
PATH="/usr/local/bin:$(perl -e 'print join ":", grep { $_ ne "/usr/local/bin" } split/:/, $ENV{PATH};')"
PATH="~/bin:$(perl -e 'print join ":", grep { $_ ne "~/bin" } split/:/, $ENV{PATH};')"
PATH=".:$(perl -e 'print join ":", grep { $_ ne "." } split/:/, $ENV{PATH};')"

[ -z "$TMUX" ] && tmx

export SVN_EDITOR=vim
export EDITOR=vim

# useful alias
alias rm="rm -i"
alias mv="mv -i"
alias ll="ls -lF"
alias la="ll -A"
alias lh="ll -h"
alias cp="cp -i"
alias dh='df -H'
alias ptt="ssh bbsu@ptt.cc"
alias p2="ssh bbsu@ptt2.cc"
alias gs="git status"
alias v="vim"
alias ev="vim ~/.vimrc"
alias eb="vim ~/.bashrc"

# rvm
[ -s ~/.rvm/scripts/rvm ] && . ~/.rvm/scripts/rvm

# perlbrew
[ -f ~/perl5/perlbrew/etc/bashrc ] && . ~/perl5/perlbrew/etc/bashrc

# fucntions
csie () {
    if [ -n "$1" ]; then
        ssh r00922006@linux"$1".csie.org
    else
        ssh r00922006@linux15.csie.org
    fi
}

ip () {
    if [ -z "$1" ]; then
        if [ `uname` = 'Darwin' ]; then
            local interface='en1'
        else
            local interface='eth0'
        fi
    else
        local interface="$1"
    fi
    ifconfig "$interface" | sed -En 's/.*inet ([^ ]+).*/\1/p'
}

function git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
    echo "("${ref#refs/heads/}") ";
}

function prompt_command {
    newPWD=`echo -n $PWD | perl -p -e "s{$HOME}{~}"`
    local temp="❤ 11:11 [${newPWD}] $(git_branch) "
    let fillsize="${COLUMNS}-${#temp}"
    if [ "$fillsize" -gt "0" ]; then
        fill=`perl -e 'print "-"x200;'`
        fill="${fill:0:${fillsize}}"
    fi
}

# for Mac OSX
if [ `uname` = "Darwin" ]; then
    # alias
    alias ls="ls -GF"
    alias gitx="open . -a gitx"
    alias app="open -a"
    alias hide="chflags hidden ~/Desktop/*"
    alias show="chflags nohidden ~/Desktop/*"

    # to solve OSX Lion update_terminal_cwd bug
    . /etc/bashrc

    # open in finder
    o () {
        if [ -n "$*" ]; then
            open "$*"
        else
            open .
        fi
    }

    # macvim
    svim () {
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

    # git completion
    [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ] && . `brew --prefix`/etc/bash_completion.d/git-completion.bash

    # autojump
    [ -f `brew --prefix`/etc/autojump ] && . `brew --prefix`/etc/autojump

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

# prompt
# ★  15:36 [~] ---------
# $ 
#PROMPT_COMMAND=prompt_command
#export PS1="\n\[\e[33m\]★  \[\e[36m\]\A \[\e[1;34m\][\${newPWD}] \[\e[0;35m\]\$(git_branch)\[\e[1;30m\]\${fill}\n\[\e[0m\]$ "
# [~] ➟ 
export PS1="\[\e[0;35m\]\$(git_branch)\[\e[1;30m\][\w] \[\e[0;31m\]➟ \[\e[m\]"
