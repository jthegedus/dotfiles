# Aliases
if type "macchina" > /dev/null 2>&1
  alias cl='clear && macchina && ll'
end
if type "exa" > /dev/null 2>&1
    alias ll='exa -al --group-directories-first -I .git'
    alias lt='exa -alT --group-directories-first -I .git'
#   alias ll='exa -al -I .git --git'
#   alias lt='exa -alT -I .git --git'
end
alias q='cd ~'
alias d='cd ~/dev'
alias gl='git log --all --decorate --oneline --graph'
alias gs='git status --short'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'

# Source asdf if installed
if test -f ~/.asdf/asdf.fish
    source ~/.asdf/asdf.fish
end

# Terminal start
if type "macchina" > /dev/null 2>&1
    macchina
else
    printf "Warning: macchina command not found.\n"
end

## List dirs
ll
printf "\n"

if type "starship" > /dev/null 2>&1
    starship init fish | source
else
    printf "Warning: starship command not found.\n"
end