# Use ZSH_ENV to set zsh to read configuration files from XDG locations
#
# Related documentation:
#   * https://zsh.sourceforge.io/Intro/intro_3.html
#   * https://specifications.freedesktop.org/basedir-spec/latest/
# Inspired by:
#   * https://stackoverflow.com/a/46962370
#   * https://github.com/BreadOnPenguins/dots/blob/master/.zprofile

# Default Programs
export EDITOR="hx"
export TERM="ghostty"
export TERMINAL="ghostty"
export BROWSER="chromium"
export BROWSER2="firefox"

# User-specific directories
# Only set if not already defined to preserve system-set values
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Set ZDOTDIR
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"
