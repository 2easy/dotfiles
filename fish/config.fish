if status is-interactive
# Commands to run in interactive sessions can go here
end

if test -d /opt/homebrew/bin
    # Apple Silicon Mac
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
end