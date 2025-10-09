# G - Modern ls replacement with enhanced features
if command --query g
    # Initialize g completion for Fish shell
    g --init fish | source

    # Override ll alias to use g when available
    # Use long flags for clarity since g is a cross-platform Homebrew tool
    alias ll 'g --almost-all --long --human-readable'
end