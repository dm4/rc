# Fix SSH agent socket
if [ -S "$SSH_AUTH_SOCK" -a "$SSH_AUTH_SOCK" != "$HOME/.ssh/ssh_auth_sock" ]; then
    mkdir -p "$HOME/.ssh/"
    ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
fi
export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"

# tmux setup
[ -t 1 ] && [ -z "$TMUX" ] && [ -z "$VSCODE" ] && [ -f ~/.tmux-auto ] && [ -x ~/bin/tmx ] && ~/bin/tmx

# PS1 placeholder for fake speed up!
[ -t 1 ] && printf '\e[s[~] ➟  '

# Path
export PATH=".:$HOME/bin:$HOME/.local/bin:$PATH"

# Editor
export SVN_EDITOR=vim
export EDITOR=vim

# History
export HISTCONTROL=ignoreboth
export HISTFILESIZE=${HISTSIZE}
export HISTSIZE=10000
export HISTTIMEFORMAT='%F %T '

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
alias gap="git add -p"
alias gcm="git commit -m"
alias gd="git diff"
alias gdf="git --no-pager diff --name-only"
alias gds="git diff --staged"
alias gdw="git diff --word-diff"
alias gr="git remote -v"
alias gs="git status"
alias ev="vim ~/.vimrc"
alias eb="vim ~/.bashrc"
alias et="vim ~/.tmux.conf"
alias en="vim ~/.config/nvim"
alias p="perl -e 'print \$_, \"\\n\" for split /:/, \$ENV{PATH}'"
alias svndi="svn di | colordiff"
alias dps='docker ps --format "table {{.Names}}\t{{.ID}}\t{{.Networks}}\t{{.Status}}\t{{.RunningFor}}"'
alias dpsa='docker ps -a --format "table {{.Names}}\t{{.ID}}\t{{.Networks}}\t{{.Status}}\t{{.RunningFor}}"'
alias dpse='docker ps -a --format "table {{.Names}}\t{{.ID}}\t{{.Networks}}\t{{.Status}}\t{{.RunningFor}}" --filter status=exited'
alias drm="docker rm"
alias drmi="docker rmi"
alias dstop="docker stop"
alias dstart="docker start"
alias sshn="ssh -o StrictHostKeyChecking=no"
alias vim="nvim"
alias vimu="vim -u /dev/null"
alias list-pipenv='for venv in ~/.local/share/virtualenvs/* ; do basename $venv; cat $venv/.project | sed "s/\(.*\)/\t\1\n/" ; done'
alias psgrep="ps aux | grep -vE '(ps|grep)' | grep -i"
[ -n "$(which hub)" ] && alias git=hub

# pyenv
[ -n "$(which pyenv)" ] && eval "$(pyenv init -)"

# rbenv
[ -n "$(which rbenv)" ] && eval "$(rbenv init - bash)"

# cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# ghc
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# .bashrc.local
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"

# nvm
nvm_commands=(node npm nvm)
lazy_load_nvm() {
    unset -f "${nvm_commands[@]}"
    export NVM_DIR="$HOME/.nvm"
    local nvm_sh_path="$NVM_DIR/nvm.sh"
    [ "$(uname)" = Darwin ] && nvm_sh_path=/usr/local/opt/nvm/nvm.sh
    [ -s "$nvm_sh_path" ] && source "$nvm_sh_path"
}
for nvm_command in "${nvm_commands[@]}"
do
    eval "${nvm_command}() { lazy_load_nvm; ${nvm_command} \"\$@\"; }"
done

# Functions

function len { echo ${#1}; }
function mkcd { mkdir -p "$@" && cd "$@"; }
function newx { touch "$1" && chmod +x "$1"; }

function t {
    if [ `uname` = 'Darwin' ]; then
        date -r "$1"
    else
        date -d "+@$1"
    fi
}

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

function remove_known_host {
    [ -n "$1" ] && sed -i '' "$1d" ~/.ssh/known_hosts
}

function yaml2json {
    [ -n "$1" ] && [ -f "$1" ] && python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < "$1"
}

function forward_port_local {
    local host="$1"
    local port="$2"
    [ -z "$port" ] && echo "$FUNCNAME <host> <port>" && return
    [ -z "$host" ] && echo "$FUNCNAME <host> <port>" && return
    ssh -L "$port:localhost:$port" -N "$host"
}

function pchome {
    echo "在 PChome 24 上搜尋 $* ..."
    curl -s --get \
        --data-urlencode "q=$*" \
        --data-urlencode 'sort=sale/dc' \
        'https://ecshweb.pchome.com.tw/search/v3.3/all/results' \
        | jq -r '.prods[] | "- $" + (.price | tostring) + "\t" + .name + "\thttps://24h.pchome.com.tw/prod/" + .Id'
}

function iterm_notify {
    echo $'\e]9;'"$*"$'\007'
}

# git-prompt setting
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
[ -f ~/.rc/git-prompt.sh ] && source ~/.rc/git-prompt.sh

# prompt setting
# [~] ➟
md5_cmd=md5sum
[ -z "$(which $md5_cmd)" ] && md5_cmd=md5
arrow_color_number=$(printf "%d" 0x$(hostname | $md5_cmd | cut -c 1))
arrow_color_number=$(expr $arrow_color_number % 6 + 31)
git_prompt_color_number=$(printf "%d" 0x$(hostname | $md5_cmd | cut -c 2))
git_prompt_color_number=$(expr $git_prompt_color_number % 6 + 31)
arrow_color="\[\e[0;${arrow_color_number}m\]"
git_prompt_color="\[\e[0;${git_prompt_color_number}m\]"
clear_color="\[\e[m\]"
tmux_title='\[\e]2;$(hostname -s)\e\\\]'
prompt_command() {
    history -a
    history -c
    history -r
}
export PS1="${tmux_title}${git_prompt_color}\$(__git_ps1 '(%s) ')${clear_color}[\w] ${arrow_color}➟  ${clear_color}"
export PROMPT_COMMAND=prompt_command

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS='--height 30% --reverse --border'

# dircolors
[ -f ~/.dircolors ] && [ -n "$(which dircolors)" ] && eval $(dircolors -b ~/.dircolors)

# macOS
if [ `uname` = "Darwin" ]; then
    # https://support.apple.com/zh-tw/HT208050
    export BASH_SILENCE_DEPRECATION_WARNING=1

    # alias
    alias ls="ls -HGF"
    alias app="open -a"
    alias hide="chflags hidden ~/Desktop/*"
    alias show="chflags nohidden ~/Desktop/*"
    alias xcode="find . -name '*.xcodeproj' -exec open {} \;"
    alias lsusb="system_profiler SPUSBDataType"
    alias lsb_release="system_profiler SPSoftwareDataType"
    alias flush_dns_cache="sudo killall -HUP mDNSResponder"
    alias adapter="ioreg -rw0 -c AppleSmartBattery | grep AdapterDetails | head -n 1 | tr '{,' $'\n' | tr -d '})' | tail -n +2"

    # ENV variables
    export PATH="/opt/homebrew/bin:$PATH"
    export GOPATH="$HOME/work/go"
    export GOROOT="$(brew --prefix golang)/libexec"
    export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
    export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

    # bash completions
    [ -f `brew --prefix`/etc/bash_completion ] && . `brew --prefix`/etc/bash_completion

    # autojump
    [ -f `brew --prefix`/etc/autojump.sh ] && . `brew --prefix`/etc/autojump.sh

    # gpg-agent for ssh
    [ -S $HOME/.gnupg/S.gpg-agent.ssh ] && ln -sf "$HOME/.gnupg/S.gpg-agent.ssh" "$HOME/.ssh/ssh_auth_sock"

    # chruby
    [ -f `brew --prefix`/opt/chruby/share/chruby/chruby.sh ] && . `brew --prefix`/opt/chruby/share/chruby/chruby.sh
    [ -f `brew --prefix`/opt/chruby/share/chruby/auto.sh ] && . `brew --prefix`/opt/chruby/share/chruby/auto.sh

    # iTerm
    test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

# Linux
if [ `uname` = "Linux" ]; then
    # ENV variables
    export GOPATH=${HOME}/go
    export PATH=$GOPATH/bin:$PATH

    # Aliases
    alias gnome-logout='gnome-session-quit --logout --no-prompt'

    # aotujump
    [ -f /usr/share/autojump/autojump.bash ] && . /usr/share/autojump/autojump.bash

    # numlockx for Keychron bluetooth keyboards
    [ -n "$(which numlockx)" ] && xhost &>/dev/null && numlockx off
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

# Clear placeholder
[ -t 1 ] && printf '\e[2K\e[u'
