# Disable Claude Code auto-updater if claude is installed via homebrew
if command -v claude &> /dev/null; then
    CLAUDE_PATH=$(command -v claude)
    if [[ "$CLAUDE_PATH" == *"/homebrew/"* ]] || [[ "$CLAUDE_PATH" == *"/linuxbrew/"* ]]; then
        export DISABLE_AUTOUPDATER=1
    fi
fi
