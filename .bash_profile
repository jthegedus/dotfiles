# Use skeleton .bashrc, .bash_profile, .bash_logout configurations
# to define configuration under the $XDG_CONFIG_HOME/bash directory

# Just use same behavious as defined in .bashrc
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
