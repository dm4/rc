# PS1 placeholder for fake speed up!
[ -t 1 ] && printf '\e[s[~] ➟  '

[ -f "$HOME/.rc/commonrc" ] && source "$HOME/.rc/commonrc"

# History
export HISTCONTROL=ignoreboth
export HISTFILESIZE=${HISTSIZE}
export HISTSIZE=10000
export HISTTIMEFORMAT='%F %T '

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS='--height 30% --reverse --border'

# dircolors
[ -f ~/.dircolors ] && [ -n "$(which dircolors)" ] && eval $(dircolors -b ~/.dircolors)

# rbenv
[ -d "$HOME/.rbenv/bin" ] && export PATH="$HOME/.rbenv/bin:$PATH"
[ -n "$(which rbenv)" ] && eval "$(rbenv init - bash)"

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

function yaml2json {
    [ -n "$1" ] && [ -f "$1" ] && python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < "$1"
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

# macOS
if [ `uname` = "Darwin" ]; then
    # bash completions
    [ -f `brew --prefix`/etc/bash_completion ] && . `brew --prefix`/etc/bash_completion
fi

# Linux
if [ `uname` = "Linux" ]; then
    # bash completions
    [ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
fi

# Clear placeholder
[ -t 1 ] && printf '\e[2K\e[u'
