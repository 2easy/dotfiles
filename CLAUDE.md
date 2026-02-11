# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Minimal macOS dotfiles for development. The repo is structured to be cloned to `~/dotfiles` and uses symlinks to dotfiles in `~/.config/` and `~`.

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
make symlink   # Create symlinks
make all       # Both (default)
```

## Architecture

The repository uses symlinks rather than copying files:

- **App configs** (`kitty/`, `fish/`, `nvim/`) → symlinked to `~/.config/<name>/`
- **Git configs** (`git/gitconfig`, `git/gitignore`) → symlinked to `~/.gitconfig`, `~/.gitignore`

This means edits in the repo are immediately reflected in the installed location, and vice versa.

## Key Files

- `install.sh` - Bootstrap script that installs Homebrew (if missing) and runs `make all`
- `Makefile` - Orchestrates package installation via Homebrew and symlink creation
- `Brewfile` - Defines Homebrew packages (kitty, fish, neovim, claude-code)
- `git/gitconfig` - Git configuration with aliases, colors, and includes `~/dotfiles/git/extras`
- `git/gitignore` - Global gitignore

## Git Configuration

The gitconfig references an include file at `~/dotfiles/git/extras` for user-specific or private settings that shouldn't be committed.

## Adding New Configs

1. Create the config directory in the repo root (e.g., `tool/`)
2. Add a symlink target in `make symlink` following the existing pattern
