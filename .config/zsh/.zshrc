# Aliases
alias cl='clear'
alias q='cd ~'
alias d='cd ~/dev'
# Git Aliases
alias gl='git log --all --decorate --oneline --graph'
alias gs='git status --short'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'

# Dotfiles Management
if [ -n "$HOME" ]; then
	DOTFILES_GIT_DIR_NAME=".dotfiles.git"
	alias dotfiles="git --git-dir=${HOME}/${DOTFILES_GIT_DIR_NAME} --work-tree=${HOME}"
fi

# Set up SSH agent for Bitwarden
if [ -n "$SSH_AUTH_SOCK" ]; then
	if [ "$(uname)" = "Darwin" ]; then
		SSH_AUTH_SOCK="$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
	else
		# TODO: add support for Linux
		echo "TODO: add support for Linux"
	fi
fi

# Set up Brewfile wrapper
if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi

### Terminal start ###

# git - pull dotfiles once per day
_DOTFILES_CHECK_DIR="${TMPDIR:-/tmp}" # Use TMPDIR if set, otherwise /tmp
_DOTFILES_DATE_STAMP=$(date +%Y-%m-%d)
_DOTFILES_TIMESTAMP_FILE="${_DOTFILES_CHECK_DIR}/.dotfiles_pull_${_DOTFILES_DATE_STAMP}"

if [ ! -f "$_DOTFILES_TIMESTAMP_FILE" ]; then
	if command -v dotfiles >/dev/null 2>&1; then
		printf "Checking for dotfiles updates...\n"
		if dotfiles pull; then
			# Create the timestamp file only if pull was successful
			touch "$_DOTFILES_TIMESTAMP_FILE"
		else
			printf "Warning: Dotfiles pull failed. Please check manually.\n"
		fi
	else
		printf "Warning: dotfiles command not found.\n"
	fi
fi
# End git - pull dotfiles once per day

# macchina
if command -v macchina > /dev/null 2>&1; then
	macchina
else
	printf "Warning: macchina command not found.\n"
fi

# starship
if command -v starship > /dev/null 2>&1; then
	eval "$(starship init zsh)"
else
	printf "Warning: starship command not found.\n"
fi