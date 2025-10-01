# Bash prompt configuration with git branch support

# Function to get current git branch
__git_ps1_branch() {
    git branch --show-current 2>/dev/null
}

# Build PS1 prompt
# Format: user@hostname shell /path/to/dir branch
# Colors: bright blue for user@host, bright cyan for shell, cyan for PWD, coral/orange for git branch
PS1='\[\e[1;94m\]\u@\h\[\e[0m\] \[\e[1;96m\]$(basename $SHELL)\[\e[0m\] \[\e[0;36m\]$PWD\[\e[0m\]'

# Add git branch if in a git repository
if command -v git &> /dev/null; then
    PS1="$PS1"' $(branch=$(__git_ps1_branch); if [ -n "$branch" ]; then echo -e "\[\e[38;5;173m\]$branch\[\e[0m\]"; fi)'
fi

PS1="$PS1"'\n> '

export PS1
