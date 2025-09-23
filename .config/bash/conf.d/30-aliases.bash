# This file is for aliasing system utils with shorthand commands and default flags.
# These are expected to exist on most systems.
# Do NOT add aliases for non-standard tools.

# modifications
alias ll='ls -Alh'
alias tree='tree -a -C -I .git'
alias rm='rm -Iv'
alias mv='mv -i'
alias df='df -h'
alias du='du -h -d 1'
alias p='ps aux | ugrep $1'

# custom
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias q='cd ~'
alias d='cd ~/dev'
alias cl=clear
alias gl='git log --all --decorate --oneline --graph'
alias gs='git status --short'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
