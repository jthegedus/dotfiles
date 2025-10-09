# LLA - Modern file explorer with multiple views
if command --query lla
    # Override ll alias to use lla tree view when available
    alias ll 'lla -T'

    # Search aliases
    alias search 'lla --search'
    alias rg 'lla --search'

    # Fuzzy find alias (includes hidden files with -a flag)
    alias fzf 'lla --fuzzy -a'
    alias fz 'lla --fuzzy -a'
    alias fuzz 'lla --fuzzy -a'

    # View-specific aliases
    alias lg 'lla -G'
    alias lt 'lla --timeline'
    alias lsize 'lla --sizemap --include-dirs'

    # Set up jump feature if not already configured
    if not test -f ~/.config/lla/jump_history.txt
        lla jump --setup --shell fish >/dev/null 2>&1
    end
end
