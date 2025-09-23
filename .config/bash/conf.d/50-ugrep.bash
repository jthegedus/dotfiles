# Ugrep - universal grep with additional features
if command -v ugrep &> /dev/null; then
    # Basic ugrep commands
    alias ug='ugrep'
    alias ug+='ugrep+'

    # Interactive and specialized search modes
    alias uq='ug -Q'                        # interactive TUI search (uses .ugrep config)
    alias uz='ug -z'                        # compressed files and archives search (uses .ugrep config)
    alias ux='ug -U --hexdump'              # binary pattern search (uses .ugrep config)

    # Git integration
    alias ugit='ug -R --ignore-files'       # works like git-grep & define your preferences in .ugrep config

    # Grep family replacements
    alias grep='ug -G'                      # search with basic regular expressions (BRE) like grep
    alias egrep='ug -E'                     # search with extended regular expressions (ERE) like egrep
    alias fgrep='ug -F'                     # find string(s) like fgrep
    alias zgrep='ug -zG'                    # search compressed files and archives with BRE
    alias zegrep='ug -zE'                   # search compressed files and archives with ERE
    alias zfgrep='ug -zF'                   # find string(s) in compressed files and/or archives

    # Utility commands
    alias xdump='ugrep -X ""'               # hexdump files without searching (don't use .ugrep config)
    alias zmore='ugrep+ -z -I -+ --pager ""' # view compressed, archived and regular files (don't use .ugrep config)
fi