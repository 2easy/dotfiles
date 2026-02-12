if status is-interactive
# Commands to run in interactive sessions can go here
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