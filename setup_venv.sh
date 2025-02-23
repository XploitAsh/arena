#!/bin/bash

if [[ -n "$ZSH_VERSION" ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ -n "$BASH_VERSION" ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
elif [[ -n "$FISH_VERSION" ]]; then
    SHELL_CONFIG="$HOME/.config/fish/config.fish"
else
    echo "❌ Unsupported shell detected. Please configure venv manually."
    exit 1
fi

echo "✅ Detected shell configuration: $SHELL_CONFIG"

if ! command -v python3 &> /dev/null; then
    echo "⏳ Python3 is not installed. Installing now..."
    sudo apt update && sudo apt install -y python3 python3-venv
fi

if [ ! -d "$HOME/venv" ]; then
    echo "⏳ Creating Python virtual environment..."
    python3 -m venv "$HOME/venv"
fi

if ! grep -q "source \$HOME/venv/bin/activate" "$SHELL_CONFIG"; then
    echo "🔧 Adding venv auto-activation to $SHELL_CONFIG..."
    echo 'source $HOME/venv/bin/activate' >> "$SHELL_CONFIG"
fi

if ! grep -q 'export PATH="$HOME/venv/bin:$PATH"' "$SHELL_CONFIG"; then
    echo 'export PATH="$HOME/venv/bin:$PATH"' >> "$SHELL_CONFIG"
fi

if [[ "$SHELL_CONFIG" == "$HOME/.zshrc" ]]; then
    echo "🔄 Ensuring Oh My Zsh does not override venv activation..."
    if ! grep -q 'source $HOME/venv/bin/activate' "$HOME/.zshrc"; then
        echo 'source $HOME/venv/bin/activate' >> "$HOME/.zshrc"
    fi
fi

echo "🔄 Applying changes..."
source "$SHELL_CONFIG"

echo "🎉 ✅ Virtual environment is now permanently activated in $SHELL_CONFIG"
echo "🚀 Open a new terminal, and your venv will be automatically activated!"
