#!/usr/bin/env bash

REPO_ROOT="$(dirname "$(realpath "$0")")"

# symlink all files in directories to $HOME
find "${REPO_ROOT}/.config" -type f | while read -r file; do
	relative_path="${file#${REPO_ROOT}/}"
	target="${HOME}/${relative_path}"
	mkdir -p "$(dirname "${target}")"
	# "-s --symbolic", "-f --force", "-v --verbose"
	ln -s -f -v "${file}" "${target}"
done

# symlink root Bash configuration to $HOME
ln -s -f -v "${REPO_ROOT}/.bash_logout" "${HOME}/.bash_logout"
ln -s -f -v "${REPO_ROOT}/.bash_profile" "${HOME}/.bash_profile"
ln -s -f -v "${REPO_ROOT}/.bashrc" "${HOME}/.bashrc"
# symlink root ZSH configuration to $HOME
ln -s -f -v "${REPO_ROOT}/.zshenv" "${HOME}/.zshenv"

# copy SSH config.example to config if config doesn't exist
mkdir -p "${HOME}/.ssh"
# only chmod if permissions are not already 700
if [[ "$(stat -c %a "${HOME}/.ssh" 2>/dev/null)" != "700" ]]; then
	chmod 700 "${HOME}/.ssh"
fi
if [[ -f "${REPO_ROOT}/.ssh/config.example" ]]; then
	if [[ ! -e "${HOME}/.ssh/config" ]]; then
		cp -v "${REPO_ROOT}/.ssh/config.example" "${HOME}/.ssh/config"
	else
		echo "Warning: ~/.ssh/config already exists, skipping config.example"
	fi
fi

