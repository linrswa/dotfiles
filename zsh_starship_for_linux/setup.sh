#!/usr/bin/env bash
set -e

echo "🔧 Updating package list..."
sudo apt update -y

echo "📦 Installing required packages (zsh, git, curl, mise)..."
sudo apt install -y zsh git curl

# 安裝 fzf（若無 git 則會先安裝）
if ! command -v git &> /dev/null; then
    echo "📦 Installing git..."
    sudo apt install -y git
fi

if [ ! -d "$HOME/.fzf" ]; then
    echo "🧩 Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    yes | ~/.fzf/install --all
else
    echo "✅ fzf already installed."
fi

# 安裝 mise（用 apt）
if ! command -v mise &> /dev/null; then
    echo "📦 Installing mise..."
    sudo apt install -y mise
else
    echo "✅ mise already installed."
fi

# 安裝 starship
if ! command -v starship &> /dev/null; then
    echo "🚀 Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "✅ Starship already installed."
fi

# 拷貝 starship.toml 到 ~/.config
if [ -f "./starship.toml" ]; then
    echo "⚙️  Applying Starship configuration..."
    mkdir -p ~/.config
    cp ./starship.toml ~/.config/starship.toml
else
    echo "⚠️  No starship.toml found in current directory. Skipping copy."
fi

# 設定預設 shell 為 zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "💡 Changing default shell to zsh..."
    chsh -s "$(which zsh)"
else
    echo "✅ Default shell is already zsh."
fi

# 套用 .zshrc
if [ -f "./.zshrc" ]; then
    echo "⚙️  Applying .zshrc configuration..."
    cp ./.zshrc ~/.zshrc
else
    echo "⚠️  No .zshrc found in current directory. Skipping copy."
fi

echo "🎉 Setup complete!"
echo "➡️  Please log out and log back in or run: exec zsh"

