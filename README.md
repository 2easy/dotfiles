# dotfiles

Minimal macOS dotfiles for development. Just the essentials: kitty, fish, and neovim.

## What's Included

| Tool | Purpose |
|------|---------|
| **kitty** | Fast, feature-rich terminal emulator |
| **fish** | Interactive shell with sensible defaults |
| **neovim** | Modal text editor with lazy.nvim plugin manager |
| **git** | Version control with aliases and color |

## Quick Start

```bash
# Clone the repository
git clone https://github.com/2easy/dotfiles ~/dotfiles
cd ~/dotfiles

# Run the installer
./install.sh
```

The installer will:
1. Install Homebrew (if not already installed)
2. Install kitty, fish, and neovim via Homebrew
3. Create symlinks to `~/.config/`
4. Install Fisher and fish plugins

## Manual Setup

If you prefer to run commands manually:

```bash
# Install packages
make install

# Create symlinks
make symlink
```

## Set Fish as Default Shell

```bash
# Add fish to available shells (if needed)
echo $(which fish) | sudo tee -a /etc/shells

# Set fish as default
chsh -s $(which fish)
```

## Adding Fish Plugins

Fish uses [Fisher](https://github.com/jorgebucaran/fisher) for plugin management. Plugins are defined in `fish/fish_plugins`:

```
jorgebucaran/fisher
pure-fish/pure
```

To add a new plugin, add its GitHub repo (e.g., `username/repo`) to `fish/fish_plugins`, then run:

```bash
fisher update
```

The installer automatically installs Fisher and all listed plugins.

## Adding Neovim Plugins

Edit `nvim/init.lua` and add plugins to the `setup()` call:

```lua
require("lazy").setup({
  { "folke/tokyonight.nvim" },
  { "nvim-telescope/telescope.nvim" },
  -- Add more plugins from https://dotfyle.com/plugins
}, {})
```

Then run `:Lazy` in neovim to manage plugins.

## Font

The kitty configuration uses **FiraCode Nerd Font**. Install it via:

```bash
brew tap homebrew/cask-fonts
brew install font-fira-code-nerd-font
```

Or download it from: https://www.nerdfonts.com/font-downloads

## Structure

```
~/dotfiles/
├── Makefile              # Installation orchestration
├── Brewfile              # Homebrew package definitions
├── install.sh            # Bootstrap script
├── kitty/
│   └── kitty.conf        # Terminal configuration
├── fish/
│   ├── config.fish       # Shell configuration
│   ├── fish_plugins      # Fisher plugin list
│   └── abbreviations.fish # Command shortcuts
├── nvim/
│   └── init.lua          # Neovim + lazy.nvim
└── git/
    ├── gitconfig         # Git configuration
    └── gitignore         # Global gitignore
```

## License

MIT
