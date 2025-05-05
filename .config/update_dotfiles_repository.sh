#! /usr/bin/env bash
# This script updates the dotfiles repository with the latest changes from the remote
#
# ARGUMENTS:
#   $1: The fully qualified path to the dotfiles git directory
#   $2: The fully qualified path to the dotfiles work tree

if [ -z "${1}" ]; then
    printf "%s\n" "Error: The dotfiles --git-dir must be provided."
    exit 0
fi

if [ -z "${2}" ]; then
    printf "%s\n" "Error: The dotfiles --work-tree must be provided."
    exit 0
fi

# Assign args to variables
_DOTFILES_GIT_DIR_PATH="${1}"
_DOTFILES_WORK_TREE_PATH="${2}"

# Create variables for repository update check status
_DOTFILES_CHECK_DIR="${TMPDIR:-/tmp}" # uses TMPDIR if set, otherwise defaults to /tmp
_DOTFILES_DATE_STAMP=$(date +%Y-%m-%d)
_DOTFILES_TIMESTAMP_FILE="${_DOTFILES_CHECK_DIR}/.dotfiles_pull_${_DOTFILES_DATE_STAMP}"

if [ ! -f "$_DOTFILES_TIMESTAMP_FILE" ]; then
	if git --git-dir="$_DOTFILES_GIT_DIR_PATH" --work-tree="$_DOTFILES_WORK_TREE_PATH" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		printf "%s\n" "Checking for dotfiles updates..."
		if git --git-dir="$_DOTFILES_GIT_DIR_PATH" --work-tree="$_DOTFILES_WORK_TREE_PATH" pull; then
			# Create the timestamp file only if pull was successful
			touch "$_DOTFILES_TIMESTAMP_FILE"
		else
			printf "%s\n" "Warning: Dotfiles pull failed. Please check manually."
		fi
	else
		printf "%s\n" "Warning: dotfiles repo not found at location ${_DOTFILES_REPO_LOCATION}."
	fi
fi
