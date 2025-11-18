#!/usr/bin/env bash

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

# symlink root Bash configuration to $HOME
echo "Linking root configuration files..."
ln -s -f -v "${REPO_ROOT}/.bash_logout" "${HOME}/.bash_logout"
ln -s -f -v "${REPO_ROOT}/.bash_profile" "${HOME}/.bash_profile"
ln -s -f -v "${REPO_ROOT}/.bashrc" "${HOME}/.bashrc"
# symlink root ZSH configuration to $HOME
ln -s -f -v "${REPO_ROOT}/.zshenv" "${HOME}/.zshenv"
echo

# copy SSH config.example to config if config doesn't exist
echo "Setting up SSH configuration..."
mkdir -p "${HOME}/.ssh"
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
# Check root files
for file in "${HOME}/.bash_logout" "${HOME}/.bash_profile" "${HOME}/.bashrc" "${HOME}/.zshenv"; do
	if [[ -L "$file" ]] && [[ ! -e "$file" ]]; then
		echo "Removing dead symlink: $file"
		rm -f "$file"
	fi
done
echo

echo "=== Dotfiles setup complete ==="

