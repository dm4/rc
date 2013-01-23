# update PATH
export PATH="/usr/local/share/npm/bin:$(perl -e 'print join ":", grep { $_ ne "/usr/local/share/npm/bin" } split/:/, $ENV{PATH};')"
export PATH="/usr/local/mysql/bin:$(perl -e 'print join ":", grep { $_ ne "/usr/local/mysql/bin" } split/:/, $ENV{PATH};')"
export PATH="/usr/local/sbin:$(perl -e 'print join ":", grep { $_ ne "/usr/local/sbin" } split/:/, $ENV{PATH};')"
export PATH="/usr/local/bin:$(perl -e 'print join ":", grep { $_ ne "/usr/local/bin" } split/:/, $ENV{PATH};')"
export PATH="$HOME/.rvm/bin:$(perl -e 'print join ":", grep { $_ ne "$PATH:$HOME/.rvm/bin" } split/:/, $ENV{PATH};')"
export PATH="$HOME/bin:$(perl -e 'print join ":", grep { $_ ne "$ENV{HOME}/bin" && $_ ne "~/bin" } split/:/, $ENV{PATH};')"
export PATH=".:$(perl -e 'print join ":", grep { $_ ne "." } split/:/, $ENV{PATH};')"

[ -z "$TMUX" ] && tmx

export SVN_EDITOR=vim
export EDITOR=vim

# useful alias
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias ls="ls -F --color=auto"
alias ll="ls -lh"
alias la="ll -A"
alias dh='df -H'
alias ptt="ssh bbsu@ptt.cc"
alias p2="ssh bbsu@ptt2.cc"
alias gs="git status"
alias ev="vim ~/.vimrc"
alias eb="vim ~/.bashrc"
alias pssh='ssh -o "ProxyCommand /usr/bin/nc -x sq2.cs.nctu.edu.tw:65000 %h %p"'
alias p="perl -e 'print \$_, \"\\n\" for split /:/, \$ENV{PATH}'"

# rvm
[ -s ~/.rvm/scripts/rvm ] && . ~/.rvm/scripts/rvm

# perlbrew
[ -f ~/perl5/perlbrew/etc/bashrc ] && . ~/perl5/perlbrew/etc/bashrc

# functions
v () {
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

# for powerline-bash
function _update_ps1() {
   export PS1="$(~/work/powerline-bash/powerline-bash.py $?)"
}

# for Mac OSX
if [ `uname` = "Darwin" ]; then
    # alias
    alias ls="ls -GF"
    alias app="open -a"
    alias mou="open -a mou"
    alias gitx="open -a gitx ."
    alias mp="open -a Marked"
    alias hide="chflags hidden ~/Desktop/*"
    alias show="chflags nohidden ~/Desktop/*"
    alias xcode="find . -name '*.xcodeproj' -exec open {} \;"
    alias subl="/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl"

    # ENV variables
    export JAVA_HOME=$(/usr/libexec/java_home)
    export ANDROID_HOME=/usr/local/Cellar/android-sdk/r20.0.1

    # to solve OSX Lion update_terminal_cwd bug
#    . /etc/bashrc

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

# prompt
# [~] ➟
export PS1="\[\e[0;35m\]\$(git_branch)\[\e[1;30m\][\w] \[\e[0;31m\]➟  \[\e[m\]"

# prompt
#export PROMPT_COMMAND="_update_ps1"
