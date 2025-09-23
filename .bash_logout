# Use skeleton .bashrc, .bash_profile, .bash_logout configurations
# to define configuration under the $XDG_CONFIG_HOME/bash directory

if [ -f "$XDG_CONFIG_HOME/bash/.bash_logout" ]; then
  . "$XDG_CONFIG_HOME/bash/.bash_logout"
fi
