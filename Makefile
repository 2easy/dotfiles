.PHONY: all install install-ai stow unstow restow help

DOTFILES := $(shell pwd)

all: install stow

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

stow:
	@echo "Stowing dotfiles..."
	@stow -v -d $(DOTFILES) -t $(HOME) .
	@echo "Dotfiles stowed."

unstow:
	@stow -v -d $(DOTFILES) -t $(HOME) -D .

restow:
	@stow -v -d $(DOTFILES) -t $(HOME) -R .

install-ai:
	@echo "Installing AI tools..."
ifeq ($(shell uname), Darwin)
	brew bundle --file=$(DOTFILES)/Brewfile.ai
else
	@echo "Only macOS is currently supported via Homebrew."
	@exit 1
endif

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all        - Run install and stow (default)"
	@echo "  install    - Install packages via Homebrew"
	@echo "  install-ai - Install AI tools (claude-code)"
	@echo "  stow       - Stow dotfiles into ~"
	@echo "  unstow     - Remove stowed symlinks"
	@echo "  restow     - Restow (unstow + stow)"
	@echo "  help       - Show this help message"
