if [[ "$TERM" == "xterm-ghostty" ]]; then
  export TERM="xterm-256color"
fi

eval "$(starship init zsh)"
source ~/.fzf.zsh
set -o vi
# 10ms for key sequences
KEYTIMEOUT=1

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Activate autosuggestions
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
set completion-ignore-case on


# Disable underline
(( ${+ZSH__HIGHTLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# alias ls='ls --color=auto'
alias ls='lsd'
alias la='ls -al'
alias ll='ls -al'
alias lg='lazygit'
alias vim='nvim'
alias vi='nvim'
alias cat='batcat'

eval "$(mise activate zsh)"
