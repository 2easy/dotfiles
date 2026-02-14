# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Minimal macOS dotfiles for development, managed with [GNU Stow](https://www.gnu.org/software/stow/). The repo is structured to be cloned to `~/dotfiles` and uses stow to create symlinks into `$HOME`.

## Installation

```bash
# Clone and run the installer
git clone https://github.com/2easy/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

Or manually via Make:

```bash
make install   # Install Homebrew packages
make stow      # Stow dotfiles into ~
make all       # Both (default)
```

## Architecture

The repository uses GNU Stow. The directory structure mirrors `$HOME` — stow creates symlinks from `~` into the repo. For example:

- `~/dotfiles/.config/fish/config.fish` → `~/.config/fish/config.fish`
- `~/dotfiles/.gitconfig` → `~/.gitconfig`

To add a new config, place it at the correct path relative to `$HOME` inside the repo. No Makefile changes needed. `.stow-local-ignore` controls which repo files (Makefile, README, etc.) are excluded from stowing.

## Key Files

- `install.sh` - Bootstrap script that installs Homebrew (if missing) and runs `make all`
- `Makefile` - Orchestrates package installation via Homebrew and stow operations
- `Brewfile` - Defines Homebrew packages (kitty, fish, neovim, stow, etc.)
- `.gitconfig` - Git configuration with aliases, colors, and includes `~/.gitextras`
- `.gitignore` - Global gitignore (symlinked to `~/.gitignore`)
- `.stow-local-ignore` - Files excluded from stowing

## Git Configuration

The gitconfig references an include file at `~/.gitextras` for user-specific or private settings that shouldn't be committed.

## Adding New Configs

1. Create the file at the correct path relative to `$HOME` (e.g., `.config/tool/config`)
2. Run `make restow` to update symlinks
