# Environment Variables Configuration
# Set early in the shell initialization
# so that later configurations can use them

# Default Programs
export EDITOR="hx"
export TERM="ghostty"
export TERMINAL="ghostty"
export BROWSER="chromium"
export BROWSER2="firefox"

# Set SHELL environment variable to ensure child processes knows Bash is the shell
export SHELL=/usr/bin/bash

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#
# User-specific directories
# Only set if not already defined to preserve system-set values
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
#
# System-wide directories
# Preference-ordered set of base directories to search for data files
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
# Preference-ordered set of base directories to search for configuration files
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"
#
# Note: XDG_RUNTIME_DIR is typically set by the system (eg: via pam_systemd)
# and should not be overridden here as it has specific security requirements.
# It's usually set to something like /run/user/$UID

# Set history to use XDG location
export HISTFILE="$XDG_CACHE_HOME/bash_history"
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
