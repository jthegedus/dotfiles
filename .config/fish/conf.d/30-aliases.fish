# This file is for aliasing system utils with shorthand commands and default flags.
# These are expected to exist on most systems.
# Do NOT add aliases for non-standard tools.

# modifications
# Use POSIX short flags for cross-platform compatibility (macOS BSD + Linux GNU + uutils)
alias ll 'ls -Alh'
alias rm 'rm -Iv'
alias mv 'mv -i'
alias df 'df -h'
alias du 'du -h -d 1'
alias p 'ps aux | ugrep $1'

# custom
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias q 'cd ~'
alias d 'cd ~/dev'
alias cl clear
alias gl 'git log --all --decorate --oneline --graph'
alias gs 'git status --short'
alias ga 'git add'
alias gc 'git commit --message'
alias gp 'git push'
alias gpl 'git pull'
