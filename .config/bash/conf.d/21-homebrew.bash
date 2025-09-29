# Homebrew configuration for Linux and macOS
case "$(uname)" in
    Darwin)
        # macOS - check common installation paths
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        else
            echo "Homebrew not found on $(uname)" >&2
        fi
        ;;
    Linux)
        # Linux - check system and user installation paths
        if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        elif [[ -x ~/.linuxbrew/bin/brew ]]; then
            eval "$(~/.linuxbrew/bin/brew shellenv)"
        else
            echo "Homebrew not found on $(uname)" >&2
        fi
        ;;
esac