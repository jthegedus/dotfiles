# Use ZSH_ENV to set zsh to read configuration files from XDG locations
#
# Related documentation:
#   * https://zsh.sourceforge.io/Intro/intro_3.html
#   * https://specifications.freedesktop.org/basedir-spec/latest/
# Inspired by:
#   * https://stackoverflow.com/a/46962370

# Set XDG_CONFIG_HOME & ZDOTDIR when not set
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=${HOME}/.config}
ZDOTDIR=${ZDOTDIR:=${XDG_CONFIG_HOME}/zsh}
# Remove potential trailing slashes
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME%/}
export ZDOTDIR=${ZDOTDIR%/}