if status is-interactive
  fish_config theme choose "Lava"

  # Set kitty theme once if not yet configured
  if set -q KITTY_PID; and not test -e ~/.config/kitty/themes.conf
    kitty +kitten themes --config-file-name=themes.conf Catppuccin-Mocha
  end
end

# eza abbreviations
abbr -a ls eza
abbr -a l 'eza -l'
abbr -a la 'eza -a'
abbr -a lla 'eza -la'
abbr -a lt 'eza --tree'

# neovim abbreviations
abbr -a vi nvim

# btop abbreviations
abbr -a top btop

# claude abbreviations
abbr -a c claude
abbr -a zc zclaude

if test -d /opt/homebrew/bin
    # Apple Silicon Mac
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
end

fish_add_path /usr/local/bin

set -Ux EDITOR nvim

zoxide init fish | source
