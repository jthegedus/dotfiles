# LLA - Modern file explorer with multiple views
if command --query lla
    # Override ll alias to use lla table view when available
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
    alias tree 'lla --tree'

    # Note: The 'j' jump function is manually managed in .config/fish/functions/j.fish
    # We do not use 'lla jump --setup' to avoid automatic injection into config.fish
end
