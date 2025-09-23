# Environment Variables Configuration
# These variables should be set early in the shell initialization
# so that other configurations and applications can use them.

# Default Programs
set --global --export EDITOR hx
set --global --export TERM ghostty
set --global --export TERMINAL ghostty
set --global --export BROWSER chromium
set --global --export BROWSER2 firefox

# Shell identification
# Set SHELL environment variable to ensure child processes know Fish is the shell
set --global --export SHELL /usr/bin/fish

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

# User-specific directories
# Only set if not already defined to preserve system-set values
set --query XDG_CONFIG_HOME; or set --global --export XDG_CONFIG_HOME $HOME/.config
set --query XDG_DATA_HOME; or set --global --export XDG_DATA_HOME $HOME/.local/share
set --query XDG_CACHE_HOME; or set --global --export XDG_CACHE_HOME $HOME/.cache
set --query XDG_STATE_HOME; or set --global --export XDG_STATE_HOME $HOME/.local/state

# System-wide directories
set --query XDG_DATA_DIRS; or set --global --export XDG_DATA_DIRS /usr/local/share:/usr/share
set --query XDG_CONFIG_DIRS; or set --global --export XDG_CONFIG_DIRS /etc/xdg

# Note: XDG_RUNTIME_DIR is typically set by the system (e.g., via pam_systemd)
# and should not be overridden here as it has specific security requirements.

# Set history files to use XDG locations
set --global --export LESSHISTFILE "$XDG_CACHE_HOME/less_history"
