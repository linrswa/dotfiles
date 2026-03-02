#!/bin/bash
# Install dependencies required by .zshrc
#
# Packages:
#   starship    - shell prompt
#   fzf         - fuzzy finder
#   zsh-syntax-highlighting
#   zsh-autosuggestions
#   mise        - dev tool version manager
#   lsd         - ls replacement (alias ls)
#   lazygit     - git TUI (alias lg)
#   bat         - cat replacement (alias cat)
#   tmux        - terminal multiplexer
#   neovim      - editor (alias vim/vi), GitHub release for latest version

set -e

mkdir -p ~/.local/bin

if [[ "$(uname)" == "Darwin" ]]; then
  echo "Detected macOS, using Homebrew..."
  brew install starship fzf zsh-syntax-highlighting zsh-autosuggestions \
               mise lsd lazygit bat neovim tmux
else
  echo "Detected Linux..."

  # starship
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh

  # fzf
  echo "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

  # zsh plugins
  echo "Installing zsh plugins..."
  sudo apt install -y zsh-syntax-highlighting zsh-autosuggestions

  # mise
  echo "Installing mise..."
  curl https://mise.run | sh

  # lsd, lazygit, bat, tmux
  echo "Installing lsd, bat, tmux..."
  sudo apt install -y lsd bat tmux

  # detect architecture
  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64)  NVIM_ARCH="x86_64"; LG_ARCH="x86_64" ;;
    aarch64) NVIM_ARCH="arm64";  LG_ARCH="arm64" ;;
    *)       echo "Unsupported architecture: $ARCH"; exit 1 ;;
  esac

  # lazygit (not in default apt repos, install from GitHub)
  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${LG_ARCH}.tar.gz"
  tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
  install /tmp/lazygit ~/.local/bin
  rm /tmp/lazygit /tmp/lazygit.tar.gz

  # neovim (install from GitHub for latest version)
  echo "Installing neovim..."
  curl -Lo /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"
  tar xzf /tmp/nvim.tar.gz -C ~/.local --strip-components=1
  rm /tmp/nvim.tar.gz
fi

echo "Done! All .zshrc dependencies installed."
