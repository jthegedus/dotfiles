#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(dirname "$(realpath "$0")")"

# Function to remove dead symlinks in a directory (recursively)
remove_dead_symlinks() {
	local dir="$1"
	if [[ ! -d "$dir" ]]; then
		return
	fi

	find "$dir" -type l | while read -r link; do
		if [[ ! -e "$link" ]]; then
			echo "Removing dead symlink: $link"
			rm -f "$link"
		fi
	done
}

echo "=== Setting up dotfiles ==="
echo

# Install Homebrew if not present
echo "Checking Homebrew..."
if ! command -v brew &>/dev/null; then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Add Homebrew to PATH for this session
	if [[ "$(uname)" == "Darwin" ]]; then
		if [[ -x /opt/homebrew/bin/brew ]]; then
			eval "$(/opt/homebrew/bin/brew shellenv)"
		elif [[ -x /usr/local/bin/brew ]]; then
			eval "$(/usr/local/bin/brew shellenv)"
		fi
	else
		if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
			eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		elif [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
			eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
		fi
	fi
else
	echo "Homebrew already installed"
fi
echo

# Install packages via Brewfile
echo "Installing packages..."
brew bundle --file="${REPO_ROOT}/.config/brewfile/Brewfile"
echo

# Symlink contents of .config subdirectories
echo "Linking .config contents..."
find "${REPO_ROOT}/.config" -maxdepth 1 -type d -not -path "${REPO_ROOT}/.config" | while read -r repo_dir; do
	subdir="$(basename "$repo_dir")"
	target_dir="${HOME}/.config/${subdir}"

	# Create the parent directory if it doesn't exist
	mkdir -p "$target_dir"

	# Symlink each item (file or directory) within the subdirectory
	find "$repo_dir" -maxdepth 1 -not -path "$repo_dir" | while read -r item; do
		item_name="$(basename "$item")"
		source_item="$item"
		target_item="${target_dir}/${item_name}"

		# If target is already a symlink pointing to source, skip
		if [[ -L "$target_item" ]] && [[ "$(readlink -f "$target_item")" == "$source_item" ]]; then
			echo "Already linked: $target_item"
			continue
		fi

		# If target exists as a directory (not a symlink), remove it
		# This prevents ln from creating the symlink inside the directory
		if [[ -d "$target_item" ]] && [[ ! -L "$target_item" ]]; then
			rm -rf "$target_item"
		fi

		# Create the symlink (force overwrite if it exists)
		ln -s -f -v "$source_item" "$target_item"
	done
done
echo


# copy SSH config.example to config if config doesn't exist
echo "Setting up SSH configuration..."
mkdir -p "${HOME}/.ssh"
mkdir -p "${HOME}/.ssh/control"
# Set proper SSH directory permissions
chmod 700 "${HOME}/.ssh"
if [[ -f "${REPO_ROOT}/.ssh/config.example" ]]; then
	if [[ ! -e "${HOME}/.ssh/config" ]]; then
		cp -v "${REPO_ROOT}/.ssh/config.example" "${HOME}/.ssh/config"
	else
		echo "Warning: ~/.ssh/config already exists, skipping config.example"
	fi
fi
echo

# Final cleanup: remove any remaining dead symlinks
echo "Cleaning up dead symlinks..."
remove_dead_symlinks "${HOME}/.config"
remove_dead_symlinks "${HOME}/.ssh"
echo

# Set Fish as default shell
echo "Setting up Fish shell..."
fish_path="$(command -v fish)"
if [[ -n "$fish_path" ]]; then
	if ! grep -q "$fish_path" /etc/shells; then
		echo "Adding Fish to /etc/shells (requires sudo)..."
		echo "$fish_path" | sudo tee -a /etc/shells
	fi

	if [[ "$SHELL" != "$fish_path" ]]; then
		echo "Setting Fish as default shell..."
		chsh -s "$fish_path"
	else
		echo "Fish is already the default shell"
	fi
else
	echo "Warning: Fish not found in PATH"
fi
echo

echo "=== Dotfiles setup complete ==="
echo "Restart your terminal to use Fish shell."
