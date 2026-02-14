#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"

# Change to dotfiles directory
cd "$DOTFILES"

# Check for Homebrew, install if missing
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Install packages (including stow) and stow dotfiles
echo "Running make all..."
make all

# Install Fisher and fish plugins
if command -v fish >/dev/null 2>&1; then
    echo ""
    echo "Installing Fisher and fish plugins..."
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"
    echo "Fish plugins installed successfully!"
fi

echo ""
echo "Dotfiles installed successfully!"
echo "Restart your shell or run: exec fish"
