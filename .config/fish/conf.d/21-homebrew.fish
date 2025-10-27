# Homebrew configuration for Linux and macOS
# Only run shellenv if HOMEBREW_PREFIX is not already set (avoids duplicate PATH entries)
if not set -q HOMEBREW_PREFIX
    switch (uname)
        case Darwin
            # macOS - check common installation paths
            if test -x /opt/homebrew/bin/brew
                eval (/opt/homebrew/bin/brew shellenv)
            else if test -x /usr/local/bin/brew
                eval (/usr/local/bin/brew shellenv)
            else
                echo "Homebrew not found on $(uname)" >&2
            end
        case Linux
            # Linux - check system and user installation paths
            if test -x /home/linuxbrew/.linuxbrew/bin/brew
                eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
            else if test -x ~/.linuxbrew/bin/brew
                eval (~/.linuxbrew/bin/brew shellenv)
            else
                echo "Homebrew not found on $(uname)" >&2
            end
    end
end
