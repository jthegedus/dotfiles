# Add user's local binaries to PATH
if [[ -d ~/.local/bin ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi