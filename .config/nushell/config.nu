use std/util "path add"

#######################
### Configure SHELL ###
#######################

# see env.nu

###############
### Aliases ###
###############

# common aliases
alias dir = dir --color=auto
alias grep = ugrep --color=auto
alias egrep = ugrep -E --color=auto
alias fgrep = ugrep -F --color=auto
alias tarnow = tar -acf 
alias untar = tar -zxvf 
alias wget = wget -c 

# terminal navigation
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ..... = cd ../../../..
alias ...... = cd ../../../../..
alias cl = clear
alias q = cd ~
alias d = cd ~/dev

# git aliases
alias gl = git log --all --decorate --oneline --graph
alias gs = git status --short
alias ga = git add
alias gc = git commit -m
alias gp = git push
alias gpl = git pull

# ls
alias ll = ls -a
# Do not use eza until Nushell table support is improved. See - https://github.com/eza-community/eza/issues/472
# alias ls = eza -al --color=always --group-directories-first --icons # preferred listing
# alias la = eza -a --color=always --group-directories-first --icons  # all files and dirs
# alias ll = eza -l --color=always --group-directories-first --icons  # long format
# alias lt = eza -aT --color=always --group-directories-first --icons # tree listing

# Replace some more things with better alternatives
alias cat = bat --style header --style snip --style changes --style header

# Replace grep with ripgrep
alias grep = rg

# Replace df with eza tree view
alias df = eza -T

# Replace du with eza sorted by size
alias du = eza -s size

# Specific git alias for working with the dotfiles repository
const dotfiles_git_dir_path = ($nu.home-path | path join ".dotfiles.git")
const dotfiles_work_tree_path = ($nu.home-path | str trim)
alias dotfiles = git --git-dir=($dotfiles_git_dir_path) --work-tree=($dotfiles_work_tree_path)

#####################
### Add Utilities ###
#####################

# description: backup a file with a . suffix
# usage: backup filenamebak
def backup [filename] {
    cp $filename ([$filename ".bak"] | str join)
}

# description: copy DIR1 to DIR2
# usage: copy DIR1 DIR2
def copy [from to] {
    cp -r $from $to
}

# description: update dotfiles repository if it has not been updated this calendar day
# usage: update-dotfiles
def update-dotfiles [] {
    # path format: /tmp/dotfiles.pull.YYYY-MM-DD
    let dotfiles_timestamp_file_path = $env.TMP_DIR | path join (["dotfiles" "pull" (date now | format date "%Y-%m-%d")] | str join '.')
    if not ($dotfiles_timestamp_file_path | path exists) {
        print "checking for dotfiles updates..."
        if (do { dotfiles pull } | complete | get exit_code) != 0 {
			printf "%s\n" "Warning: Dotfiles pull failed. Please check manually."
        } else {
            # Create the timestamp file only if tpull was successful
            touch $dotfiles_timestamp_file_path
        }
    }
}

##################
### Set Prompt ###
##################

# update dotfiles repository (once per day)
update-dotfiles

# carapace - shell completions
source ($nu.home-path | path join ".cache/carapace/init.nu")

# starship - prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
