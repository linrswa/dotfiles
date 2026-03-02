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
#   neovim      - editor (alias vim/vi)

set -e

if [[ "$(uname)" == "Darwin" ]]; then
  echo "Detected macOS, using Homebrew..."
  brew install starship fzf zsh-syntax-highlighting zsh-autosuggestions \
               mise lsd lazygit bat neovim
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

  # lsd, lazygit, bat, neovim
  echo "Installing lsd, lazygit, bat, neovim..."
  sudo apt install -y lsd bat neovim

  # lazygit (not in default apt repos, install from GitHub)
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit /usr/local/bin
  rm /tmp/lazygit /tmp/lazygit.tar.gz
fi

echo "Done! All .zshrc dependencies installed."
