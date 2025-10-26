# Disable Claude Code auto-updater if claude is installed via homebrew
if type -q claude
    set -l claude_path (type -p claude)
    if string match -q -r '/(homebrew|linuxbrew)/' -- $claude_path
        set -gx DISABLE_AUTOUPDATER 1
    end
end
