#######################
### Configure SHELL ###
#######################

# SSH agent - configure to use Bitwarden
if [ -n "$SSH_AUTH_SOCK" ]; then
	if [ "$(uname)" = "Darwin" ]; then
		_BITWARDEN_SOCK_PATH="$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
		if [ -S "$_BITWARDEN_SOCK_PATH" ]; then
			export SSH_AUTH_SOCK="$_BITWARDEN_SOCK_PATH"
		else
			# Warn if the socket doesn't exist but we expected it
			printf "Warning: Bitwarden SSH agent socket not found at %s. Keeping existing SSH_AUTH_SOCK: %s\n" "$_BITWARDEN_SOCK_PATH" "$SSH_AUTH_SOCK" >&2
		fi
	fi
	if [ "$(uname)" = "Linux" ]; then
		# TODO: add support for Linux for Bitwarden SSH agent
		printf "%s\n" "TODO: add support for Linux for Bitwarden SSH agent"
	fi
fi

###############
### Aliases ###
###############

# common aliases
alias dir='dir --color=auto'
alias grep='ugrep --color=auto'
alias egrep='ugrep -E --color=auto'
alias fgrep='ugrep -F --color=auto'
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '

# terminal navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cl='clear'
alias q='cd ~'
alias d='cd ~/dev'

# Git Aliases
alias gl='git log --all --decorate --oneline --graph'
alias gs='git status --short'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'

# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.='eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles

# Replace some more things with better alternatives
alias cat='bat --style header --style snip --style changes --style header'

# Replace grep with ripgrep
alias grep='rg'

# Replace df with eza tree view
alias df='eza -T'

# Replace du with eza sorted by size
alias du='eza -s size'

# Specific git alias for working with the dotfiles repository
_DOTFILES_GIT_DIR_PATH="${HOME}/.dotfiles.git"
_DOTFILES_WORK_TREE_PATH="${HOME}"
alias dotfiles="git --git-dir=${_DOTFILES_GIT_DIR_PATH} --work-tree=${_DOTFILES_WORK_TREE_PATH}"

##################
### Set Prompt ###
##################

# update dotfiles repository (once per day)
_DOTFILES_UPDATE_SCRIPT="$_DOTFILES_WORK_TREE_PATH/.config/update_dotfiles_repository.sh"
if [ -x "$_DOTFILES_UPDATE_SCRIPT" ]; then
	"$_DOTFILES_UPDATE_SCRIPT" "$_DOTFILES_GIT_DIR_PATH" "$_DOTFILES_WORK_TREE_PATH"
else
	printf "%s\n" "Warning: Dotfiles update script not found or not executable: $_DOTFILES_UPDATE_SCRIPT" >&2
fi

# carapace - shell completions
#
# NOTE: disabled due to error.
#       carapace seems to rely upon other system/zsh dependencies.
#
# if command -v carapace > /dev/null 2>&1; then
# 	export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
# 	zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
# 	source <(carapace _carapace)
# fi

# macchina - system information
if command -v macchina > /dev/null 2>&1; then
	macchina
fi

# starship - prompt
if command -v starship > /dev/null 2>&1; then
	eval "$(starship init zsh)"
fi