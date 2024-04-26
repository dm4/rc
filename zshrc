# Enable Powerlevel10k instant prompt.
if [[ -n "$TMUX" && -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# OMZ settings.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# OMZ plugins.
plugins=(fzf gh)
source $ZSH/oh-my-zsh.sh

# History timestamp.
HIST_STAMPS="%m/%d %H:%M:%S"

# Zsh not follow .inputrc, use zle settings.
bindkey "\C-p" history-beginning-search-backward
bindkey "\C-n" history-beginning-search-forward

# Common settings between bash and zsh.
[ -f $HOME/.rc/commonrc ] && source $HOME/.rc/commonrc

# p10k settings.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
