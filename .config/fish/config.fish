if test -f $HOME/.cargo/env.fish
    source $HOME/.cargo/env.fish
end

# Run commands only in interactive sessions
if status is-interactive
    # Initialize zoxide
    zoxide init fish | source

    # Initialize starship
    starship init fish | source
end

# Add directories to PATH safely
fish_add_path /usr/local/bin
fish_add_path /home/jan/zig/build/stage3/bin
fish_add_path /usr/local/zig
fish_add_path $HOME/.cargo/bin
