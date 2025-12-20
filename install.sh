#!/usr/bin/env bash
set -euo pipefail
shopt -s dotglob

REPO_ROOT="$(dirname "$(realpath "$0")")"

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

# Collect items to symlink (relative paths from repo root)
echo "Collecting dotfiles..."
symlink_items=()

# .config subdirectories: symlink immediate children of each subdir
for subdir in "${REPO_ROOT}/.config"/*/; do
	[[ -d "$subdir" ]] || continue
	for item in "$subdir"*; do
		[[ -e "$item" ]] || continue
		symlink_items+=("${item#"$REPO_ROOT"/}")
	done
done

# .ssh: symlink all files/directories
for item in "${REPO_ROOT}/.ssh"/*; do
	[[ -e "$item" ]] || continue
	symlink_items+=("${item#"$REPO_ROOT"/}")
done

# Create parent directories
echo "Creating directories..."
for rel_path in "${symlink_items[@]}"; do
	mkdir -p "$(dirname "${HOME}/${rel_path}")"
done

# SSH directory permissions
if [[ -d "${HOME}/.ssh" ]]; then
	chmod 700 "${HOME}/.ssh"
	mkdir -p "${HOME}/.ssh/control"
fi

# Create symlinks
echo "Linking dotfiles..."
for rel_path in "${symlink_items[@]}"; do
	source="${REPO_ROOT}/${rel_path}"
	target="${HOME}/${rel_path}"

	if [[ -L "$target" ]] && [[ "$(readlink -f "$target")" == "$source" ]]; then
		echo "Already linked: ${rel_path}"
		continue
	fi

	# Remove existing directory to prevent symlink being created inside it
	if [[ -d "$target" ]] && [[ ! -L "$target" ]]; then
		rm -rf "$target"
	fi

	ln -s -f -v "$source" "$target"
done
echo

# Clean up dead symlinks
echo "Cleaning up dead symlinks..."
for dir in "${HOME}/.config" "${HOME}/.ssh"; do
	[[ -d "$dir" ]] || continue
	find "$dir" -type l ! -exec test -e {} \; -delete -print
done
echo

# Set Fish as default shell (only if not already)
echo "Checking Fish shell..."
fish_path="$(command -v fish || true)"
if [[ -z "$fish_path" ]]; then
	echo "Warning: Fish not found in PATH"
else
	# Get actual login shell from system database (not $SHELL which is stale)
	if [[ "$(uname)" == "Darwin" ]]; then
		current_shell="$(dscl . -read /Users/"$(whoami)" UserShell | awk '{print $2}')"
	else
		current_shell="$(getent passwd "$(whoami)" | cut -d: -f7)"
	fi

	if [[ "$current_shell" == "$fish_path" ]]; then
		echo "Fish is already the default shell"
	else
		if ! grep -q "$fish_path" /etc/shells; then
			echo "Adding Fish to /etc/shells (requires sudo)..."
			echo "$fish_path" | sudo tee -a /etc/shells
		fi
		echo "Setting Fish as default shell..."
		chsh -s "$fish_path"
	fi
fi
echo

echo "=== Dotfiles setup complete ==="
echo "Restart your terminal to use Fish shell."
