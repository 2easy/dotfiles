# dotfiles

Minimal macOS dotfiles for development, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

| Tool | Purpose |
|------|---------|
| **kitty** | Fast, feature-rich terminal emulator |
| **fish** | Interactive shell with sensible defaults |
| **neovim** | Modal text editor with lazy.nvim plugin manager |
| **git** | Version control with aliases and color |
| **bat** | A cat clone with syntax highlighting |

## Prerequisites

Install [Homebrew](https://brew.sh) (this also installs Xcode Command Line Tools):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then install git:

```bash
brew install git
```

## Quick Start

```bash
git clone https://github.com/2easy/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

The installer will:
1. Install Homebrew packages (including stow) via `Brewfile`
2. Stow dotfiles into `~` (creating symlinks)
3. Install Fisher and fish plugins

## Manual Setup

```bash
make install   # Install Homebrew packages
make stow      # Stow dotfiles into ~
make unstow    # Remove stowed symlinks
make restow    # Restow (unstow + stow)
```

## How Stow Works

The repo directory structure mirrors `$HOME`. Stow creates symlinks from `~` into the repo:

```
~/dotfiles/.config/fish/config.fish  →  ~/.config/fish/config.fish
~/dotfiles/.gitconfig                →  ~/.gitconfig
```

To add a new config, just place it at the correct path relative to `$HOME` inside the repo. No Makefile changes needed.

## Set Fish as Default Shell

```bash
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```

## Structure

```
~/dotfiles/
├── .config/
│   ├── bat/config           # bat configuration
│   ├── fish/
│   │   ├── config.fish      # Shell configuration
│   │   └── fish_plugins     # Fisher plugin list
│   └── kitty/
│       └── kitty.conf       # Terminal configuration
├── .gitconfig               # Git configuration
├── .gitignore               # Global gitignore
├── .gitmessage              # Commit message template
├── .stow-local-ignore       # Files stow should skip
├── Brewfile                 # Homebrew packages
├── Makefile                 # Task runner
├── install.sh               # Bootstrap script
└── scripts/
    └── kitty.sh             # Kitty theme setup
```

## License

MIT
