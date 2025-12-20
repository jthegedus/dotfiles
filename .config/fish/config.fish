# Environment Variables
set -gx EDITOR hx
set -gx SHELL /usr/bin/fish

# XDG Base Directory Specification
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache
set -q XDG_STATE_HOME; or set -gx XDG_STATE_HOME $HOME/.local/state
set -q XDG_DATA_DIRS; or set -gx XDG_DATA_DIRS /usr/local/share:/usr/share
set -q XDG_CONFIG_DIRS; or set -gx XDG_CONFIG_DIRS /etc/xdg

# Set XDG usage for programs
set -gx LESSHISTFILE "$XDG_CACHE_HOME/less_history"
set -gx VIMINIT 'source $XDG_CONFIG_HOME/vim/.vimrc'

# SSH Check toggle
set -q ENABLE_SSH_CHECK; or set -gx ENABLE_SSH_CHECK 1

# SSH agent - Bitwarden
set -l bw_sock_path
switch (uname)
    case Darwin
        set bw_sock_path "$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
    case Linux
        set bw_sock_path "$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
end
if test -S "$bw_sock_path"
    set -gx SSH_AUTH_SOCK "$bw_sock_path"
else
    echo "Error: Bitwarden SSH agent socket not found at $bw_sock_path" >&2
end

# PATH
fish_add_path ~/.local/bin

# Homebrew
if not set -q HOMEBREW_PREFIX
    switch (uname)
        case Darwin
            if test -x /opt/homebrew/bin/brew
                eval (/opt/homebrew/bin/brew shellenv)
            else if test -x /usr/local/bin/brew
                eval (/usr/local/bin/brew shellenv)
            end
        case Linux
            if test -x /home/linuxbrew/.linuxbrew/bin/brew
                eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
            else if test -x ~/.linuxbrew/bin/brew
                eval (~/.linuxbrew/bin/brew shellenv)
            end
    end
end

# Claude Code - disable auto-updater if homebrew-installed
if type -q claude
    set -l claude_path (type -p claude)
    if string match -qr '/(homebrew|linuxbrew)/' -- $claude_path
        set -gx DISABLE_AUTOUPDATER 1
    end
end

abbr ls 'ls -AHFG'
abbr ll 'ls -AHFGho'
# Aliases - toybox with fallback to system
# abbr ls 'toybox ls -ACp --color=auto'
# abbr ll 'toybox ls -Achop! --color=auto'
# abbr rm 'toybox rm -iv'
# abbr mv 'toybox mv -i'
# abbr cp 'toybox cp'
# abbr cat 'toybox cat'
# abbr df 'toybox df -h'
# abbr du 'toybox du -h -d 1'
# abbr mkdir 'toybox mkdir'
# abbr rmdir 'toybox rmdir'
# abbr touch 'toybox touch'
# abbr chmod 'toybox chmod'
# abbr chown 'toybox chown'
# abbr grep 'toybox grep'
# abbr sed 'toybox sed'
# abbr awk 'toybox awk'
# abbr sort 'toybox sort'
# abbr uniq 'toybox uniq'
# abbr head 'toybox head'
# abbr tail 'toybox tail'
# abbr cut 'toybox cut'
# abbr tr 'toybox tr'
# abbr wc 'toybox wc'
# abbr find 'toybox find'
# abbr which 'toybox which'
# abbr xargs 'toybox xargs'
# abbr date 'toybox date'
# abbr basename 'toybox basename'
# abbr dirname 'toybox dirname'
# abbr wget 'toybox wget'

# Navigation
abbr p 'ps aux | grep'
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'
abbr ..... 'cd ../../../..'
abbr ...... 'cd ../../../../..'
abbr q 'cd ~'
abbr d 'cd ~/dev'
abbr cl clear

# Git
abbr gl 'git log --all --decorate --oneline --graph'
abbr gs 'git status --short'
abbr ga 'git add'
abbr --set-cursor gc 'git commit --message "%"'
abbr gp 'git push'
abbr gpf 'git push --force'
abbr gpl 'git pull'

# Regex generation (grex)
abbr rx grex
abbr rxd 'grex --digits'
abbr rxw 'grex --words'
abbr rxs 'grex --spaces'

# AST-based search (ast-grep)
abbr sg ast-grep
abbr --set-cursor sgp 'ast-grep --pattern "%"'
abbr --set-cursor sgl 'ast-grep --pattern "%" --lang '

# Antigravity
fish_add_path $HOME/.antigravity/antigravity/bin
