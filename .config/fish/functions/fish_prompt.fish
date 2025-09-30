function fish_prompt --description 'Simple prompt'
    printf '%s%s@%s %s%s%s %s%s%s\n$ ' \
        (set_color brblue) $USER $hostname \
        (set_color brcyan) (basename $SHELL) (set_color normal) \
        (set_color $fish_color_cwd) $PWD (set_color normal)
end
