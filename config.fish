if status is-interactive
    # Commands to run in interactive sessions can go here
end

if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
   alias 02p 'sudo  ./scripts/init_db.sh'
end

if status is-interactive
and not set -q TMUX
    exec tmux
end

set -x PATH $PATH /sbin/

function ll
    ls -lh $argv
end


