eval "$(starship init zsh)"
source <(fzf --zsh)
set -o vi

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Activate syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# Disable underline
(( ${+ZSH__HIGHTLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Activate autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
set completion-ignore-case on

# alias ls='ls --color=auto'
alias ls='lsd'
alias la='ls -al'
alias ll='ls -al'
alias cleanXcode='rm -rf ~/Library/Developer/Xcode/DerivedData'
alias lg='lazygit'
alias vim='nvim'
alias vi='nvim'
alias cat='bat'


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/rswa/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/rswa/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/rswa/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/rswa/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export VCPKG_ROOT="/Users/rswa/vcpkg"
export PATH="$VCPKG_ROOT:$PATH"
export DISPLAY=:0
