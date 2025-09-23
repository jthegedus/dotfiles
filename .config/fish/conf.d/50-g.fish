# G - Modern ls replacement with enhanced features
if command --query g
    # Initialize g completion for Fish shell
    g --init fish | source

    # Override ll alias to use g when available
    alias ll 'g --almost-all --long --human-readable'
end