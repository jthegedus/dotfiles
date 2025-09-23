# Use skeleton .bashrc, .bash_profile, .bash_logout configurations
# to define configuration under the $XDG_CONFIG_HOME/bash directory

# Source global definitions
if [[ -f /etc/bashrc ]]; then
    . /etc/bashrc
fi

# Set XDG_CONFIG_HOME for use below.
# XDG_* is properly set in XDG_CONFIG_HOME/bash/conf.d/00-environment.bash
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Define local helper function for sourcing .bash files
source_bash_files() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        for file in "$dir"/*.bash; do
            [[ -r "$file" ]] && . "$file"
        done
    fi
}

# Source user custom Bash configurations following the
# Apache conf.d/* pattern as used in the Fish shell
source_bash_files "$XDG_CONFIG_HOME/bash/conf.d"

# Source function definitions
source_bash_files "$XDG_CONFIG_HOME/bash/functions"

# Clean up - unset the helper function
unset -f source_bash_files
