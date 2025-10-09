# G - Modern ls replacement with enhanced features
if command -v g &> /dev/null; then
    eval "$(g --init bash)"

    # Override ll alias to use g when available
    # Use long flags for clarity since g is a cross-platform Homebrew tool
    alias ll='g --almost-all --long --human-readable'
fi