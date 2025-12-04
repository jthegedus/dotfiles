function fish_prompt --description 'Simple prompt'
    # Get current git branch if in a git repository
    set -l git_branch (git branch --show-current 2>/dev/null)
    set -l icon (test (id -u) -eq 0; and echo '#'; or echo '%')

    # Build the prompt
    printf '%s%s@%s%s %s%s%s %s%s%s' \
        (set_color brblue) $USER $hostname (set_color normal) \
        (set_color brcyan) (basename $SHELL) (set_color normal) \
        (set_color $fish_color_cwd) $PWD (set_color normal)

    # Add git branch if available
    if test -n "$git_branch"
        printf ' %s%s%s' \
            (set_color d77757) $git_branch (set_color normal)
    end

    printf '\n%s%s%s' \
        (set_color normal) $icon (set_color normal)
end
