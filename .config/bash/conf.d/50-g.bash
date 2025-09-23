# G - Modern ls replacement with enhanced features
if command -v g &> /dev/null; then
    eval "$(g --init bash)"

    # Override ll alias to use g when available
    alias ll='g -Alh'
fi