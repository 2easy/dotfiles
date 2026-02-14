if status is-interactive
  fish_config theme choose "Lava"

  # Set kitty theme once if not yet configured
  if set -q KITTY_PID; and not test -e ~/.config/kitty/themes.conf
    kitty +kitten themes --config-file-name=themes.conf Catppuccin-Mocha
  end
end

# lsd abbreviations
abbr -a ls lsd
abbr -a l 'lsd -l'
abbr -a la 'lsd -a'
abbr -a lla 'lsd -la'
abbr -a lt 'lsd --tree'

# neovim abbreviations
abbr -a vi nvim

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
