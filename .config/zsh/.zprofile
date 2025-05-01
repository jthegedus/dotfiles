# Cross-platform ZSH profile Homebrew setup test
# see - https://docs.brew.sh/Tips-N'-Tricks#loading-homebrew-from-the-same-dotfiles-on-different-operating-systems
#
# command -v brew || export PATH="/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin"
# command -v brew && eval "$(brew shellenv)"

# Pre-eval'd location on a macOS machine @2025-04-23
eval "$(/opt/homebrew/bin/brew shellenv)"
