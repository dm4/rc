# Enable Powerlevel10k instant prompt.
if [[ -n "$TMUX" && -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# OMZ settings.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
HIST_STAMPS="%m/%d %H:%M:%S"

# OMZ plugins.
plugins=(fzf gh zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# p10k settings.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Zsh not follow .inputrc, use zle settings.
bindkey "\C-p" history-beginning-search-backward
bindkey "\C-n" history-beginning-search-forward
bindkey "\C-u" backward-kill-line

# FZF settings.
export FZF_COMPLETION_TRIGGER=',,'
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border --marker="✓" --info=inline-right'
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=marker:046,bg+:000"
if command -v eza &> /dev/null
then
  FZF_PREVIEW="[ -d {} ] && eza --tree --color=always --icons=always {} | head -100 || head -100 {}"
  export FZF_CTRL_T_OPTS="--preview '$FZF_PREVIEW'"
fi
if command -v fd &> /dev/null
then
  export FZF_DEFAULT_COMMAND="fd --hidden --follow"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  _fzf_compgen_path() {
    fd --hidden --follow "$1"
  }
  _fzf_compgen_dir() {
    fd --type d --hidden --follow "$1"
  }
fi

# Common settings between bash and zsh.
[ -f $HOME/.rc/commonrc ] && source $HOME/.rc/commonrc
