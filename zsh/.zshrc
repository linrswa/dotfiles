export PATH="$HOME/.local/bin:$PATH"
if [[ "$(uname)" == "Linux" && "$TERM" == "xterm-ghostty" ]]; then
  export TERM="xterm-256color"
fi

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

if (( $+commands[fzf] )) && [[ "$(uname)" == "Darwin" ]]; then
  source <(fzf --zsh)
elif [[ -f "$HOME/.fzf.zsh" ]]; then
  source ~/.fzf.zsh
fi
set -o vi
# 10ms for key sequences
KEYTIMEOUT=1

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Activate syntax highlighting
if [[ "$(uname)" == "Darwin" ]]; then
  zsh_syntax_highlighting="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -f "$zsh_syntax_highlighting" ]] && source "$zsh_syntax_highlighting"
elif [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Disable underline
(( ${+ZSH__HIGHTLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Activate autosuggestions
if [[ "$(uname)" == "Darwin" ]]; then
  zsh_autosuggestions="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -f "$zsh_autosuggestions" ]] && source "$zsh_autosuggestions"
elif [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
set completion-ignore-case on

# alias ls='ls --color=auto'
alias ls='lsd'
alias la='ls -al'
alias ll='ls -al'
alias lg='lazygit'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias j='just'
alias ta='tmux attach -t'

if [[ "$(uname)" == "Darwin" ]]; then
  alias cat='bat'
  alias cleanXcode='rm -rf ~/Library/Developer/Xcode/DerivedData'
  alias server='ssh server'
  alias homelab='ssh homelab'
else
  alias cat='batcat'
fi

if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi

if [[ "$(uname)" == "Darwin" ]]; then
  [[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"
  if (( $+commands[uv] )); then
    eval "$(uv generate-shell-completion zsh)"
  fi
fi
