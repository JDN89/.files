if status is-interactive
    # Commands to run in interactive sessions can go here
end

if type -q exa
    alias ll "exa -l -g --icons"
    alias lla "ll -a"
end

set -x PATH $PATH /sbin/

function ll
    ls -lh $argv
end

# SCRIPTS
 alias cgi 'sudo  ~/scripts/cgi.sh'

# zoxide init fish | source
# set -gx PATH $PATH /usr/local/go/bin

# Add zoxide to your shell
zoxide init fish | source

# Set up fzf key bindings
# fzf --fish | source
# OG binding was Ctrl + Alt + L changed it to Ctrl + Alt + L
# fzf_configure_bindings --git_log=^G

set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"
