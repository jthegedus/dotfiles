#######################
### Configure SHELL ###
#######################

# Fish - apply .profile
if test -f ~/.fish_profile
	source ~/.fish_profile
end
if test -f ~/.config/fish/.fish_profile
	source ~/.config/fish/.fish_profile
end

# SSH agent - configure to use Bitwarden
if test -n "$SSH_AUTH_SOCK"
	# Check if running on macOS
	if test (uname) = "Darwin"
		# Define the expected path for the Bitwarden SSH agent socket
		set -l bw_sock_path "$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
		# Check if the Bitwarden socket exists and is actually a socket file
		if test -S "$bw_sock_path"
			# Set SSH_AUTH_SOCK to the Bitwarden agent socket and export it globally
			set -gx SSH_AUTH_SOCK "$bw_sock_path"
		else
			# Warn if the socket doesn't exist but we expected it
			echo "Warning: Bitwarden SSH agent socket not found at $bw_sock_path. Keeping existing SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
		end
	end

	if test (uname) = "Linux"
		# TODO: add support for Linux for Bitwarden SSH agent
		echo "TODO: add support for Linux for Bitwarden SSH agent"
	end
end

###############
### Aliases ###
###############

# common aliases
alias dir 'dir --color=auto'
alias grep 'ugrep --color=auto'
alias egrep 'ugrep -E --color=auto'
alias fgrep 'ugrep -F --color=auto'
alias tarnow 'tar -acf '
alias untar 'tar -zxvf '
alias wget 'wget -c '

# terminal navigation
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias cl 'clear'
alias q 'cd ~'
alias d 'cd ~/dev'

# git aliases
alias gl 'git log --all --decorate --oneline --graph'
alias gs 'git status --short'
alias ga 'git add'
alias gc 'git commit -m'
alias gp 'git push'
alias gpl 'git pull'

# Replace ls with eza
alias ls 'eza -al --color=always --group-directories-first --icons' # preferred listing
alias la 'eza -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll 'eza -l --color=always --group-directories-first --icons'  # long format
alias lt 'eza -aT --color=always --group-directories-first --icons' # tree listing
alias l. 'eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles

# Replace some more things with better alternatives
alias cat 'bat --style header --style snip --style changes --style header'

# Replace grep with ripgrep
alias grep 'rg'

# Replace df with eza tree view
alias df 'eza -T'

# Replace du with eza sorted by size
alias du 'eza -s size'

# Specific git alias for working with the dotfiles repository
set _DOTFILES_GIT_DIR_PATH "$HOME/.dotfiles.git"
set _DOTFILES_WORK_TREE_PATH "$HOME"
alias dotfiles "git --git-dir=$_DOTFILES_GIT_DIR_PATH --work-tree=$_DOTFILES_WORK_TREE_PATH"

#####################
### Add Utilities ###
#####################

# description: backup a file with a .bak suffix
# usage: backup filename
function backup --argument filename
	cp $filename $filename.bak
end

# description: copy DIR1 to DIR2
# usage: copy DIR1 DIR2
function copy
	set count (count $argv | tr -d \n)
	if test "$count" = 2; and test -d "$argv[1]"
		set from (echo $argv[1] | string trim --right --chars=/)
		set to (echo $argv[2])
		command cp -r $from $to
	else
		command cp $argv
	end
end

##################
### Set Prompt ###
##################

# update dotfiles repository (once per day)
set _DOTFILES_UPDATE_SCRIPT "$_DOTFILES_WORK_TREE_PATH/.config/update_dotfiles_repository.sh"
if status --is-interactive; and test -x "$_DOTFILES_UPDATE_SCRIPT"
	"$_DOTFILES_UPDATE_SCRIPT" "$_DOTFILES_GIT_DIR_PATH" "$_DOTFILES_WORK_TREE_PATH"
else
	echo "Warning: Dotfiles update script not found or not executable: $_DOTFILES_UPDATE_SCRIPT" >&2
end

# carapace - shell completions
if status --is-interactive; and type -q carapace
	set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
	carapace _carapace | source
end

# macchina - system information
if status --is-interactive; and type -q macchina
	macchina
end

# starship - prompt
if status --is-interactive; and type -q starship
	starship init fish | source
end
