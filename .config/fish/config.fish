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

# Aliases - toybox with fallback to system
alias ls 'toybox ls -ACp'
alias ll 'toybox ls -Achop!'
alias rm 'toybox rm -iv'
alias mv 'toybox mv -i'
alias cp 'toybox cp'
alias cat 'toybox cat'
alias df 'toybox df -h'
alias du 'toybox du -h -d 1'
alias mkdir 'toybox mkdir'
alias rmdir 'toybox rmdir'
alias touch 'toybox touch'
alias chmod 'toybox chmod'
alias chown 'toybox chown'
alias grep 'toybox grep'
alias sed 'toybox sed'
alias awk 'toybox awk'
alias sort 'toybox sort'
alias uniq 'toybox uniq'
alias head 'toybox head'
alias tail 'toybox tail'
alias cut 'toybox cut'
alias tr 'toybox tr'
alias wc 'toybox wc'
alias find 'toybox find'
alias which 'toybox which'
alias xargs 'toybox xargs'
alias date 'toybox date'
alias basename 'toybox basename'
alias dirname 'toybox dirname'
alias wget 'toybox wget'

# Navigation
alias p 'ps aux | grep'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias q 'cd ~'
alias d 'cd ~/dev'
alias cl clear

# Git
alias gl 'git log --all --decorate --oneline --graph'
alias gs 'git status --short'
alias ga 'git add'
alias gc 'git commit --message'
alias gp 'git push'
alias gpl 'git pull'

# Regex generation (grex)
alias rx 'grex'
alias rxd 'grex --digits'
alias rxw 'grex --words'
alias rxs 'grex --spaces'

# AST-based search (ast-grep)
alias sg 'ast-grep'
alias sgp 'ast-grep --pattern'
alias sgl 'ast-grep --pattern --lang'

# Antigravity
fish_add_path $HOME/.antigravity/antigravity/bin
