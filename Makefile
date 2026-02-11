.PHONY: all install symlink help

DOTFILES := $(shell pwd)
CONFIG := $(HOME)/.config

all: install symlink

install:
	@echo "Installing packages..."
ifeq ($(shell uname), Darwin)
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	brew bundle --file=$(DOTFILES)/Brewfile
else
	@echo "Only macOS is currently supported via Homebrew."
	@exit 1
endif

symlink:
	@echo "Creating symlinks..."
	@mkdir -p $(CONFIG)
	@ln -sf $(DOTFILES)/kitty $(CONFIG)/kitty
	@ln -sf $(DOTFILES)/fish $(CONFIG)/fish
	@ln -sf $(DOTFILES)/nvim $(CONFIG)/nvim
	@ln -sf $(DOTFILES)/git/gitconfig $(HOME)/.gitconfig
	@ln -sf $(DOTFILES)/git/gitignore $(HOME)/.gitignore
	@echo "Symlinks created."

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all      - Run install and symlink (default)"
	@echo "  install  - Install packages via Homebrew"
	@echo "  symlink  - Create symlinks to ~/.config"
	@echo "  help     - Show this help message"
