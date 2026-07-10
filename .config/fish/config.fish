if status is-interactive
  fish_config theme choose "Lava"
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

set -Ux brew_path /opt/homebrew

if test -d /opt/homebrew/bin
    # Apple Silicon Mac
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
end

fish_add_path /usr/local/bin
fish_add_path "$HOME/bin"

set -Ux EDITOR nvim

zoxide init fish | source

# Machine-specific overrides
if test -f $__fish_config_dir/extras.fish
    source $__fish_config_dir/extras.fish
end
