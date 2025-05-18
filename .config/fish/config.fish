# Run commands only in interactive sessions
if status is-interactive
    # Add commands for interactive sessions here
end

# Initialize zoxide (only once)
zoxide init fish | source

# Initialize startship (only once)
starship init fish | source


set -x PATH /usr/local/bin $PATH

# Add Zig to PATH
set -x PATH /home/jan/zig/build/stage3/bin $PATH
set -x PATH /usr/local/zig:$PATH
