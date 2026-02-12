#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

DOTFILES_DIR="${DOTFILES_DIR:=${HOME}/dotfiles}"
KITTY_CONFIG_DIR="${XDG_CONFIG_HOME:=${HOME}/.config}/kitty"

function configure_kitty() {
    sudo ln -fs "/Applications/kitty.app/Contents/MacOS/kitty" "${HOME}/bin/"
    sudo ln -fs "/Applications/kitty.app/Contents/MacOS/kitten" "${HOME}/bin/"

    mkdir -p "${KITTY_CONFIG_DIR}"
    ln -fs "${DOTFILES_DIR}"/kitty/* "${KITTY_CONFIG_DIR}/"

    kitty +kitten themes --config-file-name=themes.conf Catppuccin-Mocha
}

configure_kitty