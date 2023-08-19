# Set the default text editor
export EDITOR=/usr/bin/nano

# Set the prompt to show the username, hostname, and working directory
if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\][\u@\h \w]\$\[\033[00m\] '
else
    PS1='[\u@\h \w]\$ '
fi

# Enable color support for ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Define some useful aliases
alias cp='cp -i'
alias df='df -h'
alias free='free -m'
alias more='less'
alias np='nano -w PKGBUILD'

# Enable command-line completion for sudo
complete -cf sudo

# Enable checkwinsize and histappend options
shopt -s checkwinsize histappend

# Define an archive extraction function
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Enable SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


