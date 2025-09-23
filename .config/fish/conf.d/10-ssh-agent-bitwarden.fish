# SSH agent - configure to use Bitwarden
# This configuration requires Bitwarden desktop app to be installed and SSH agent enabled

# Define the expected path for the Bitwarden SSH agent socket based on OS
set --local bw_sock_path
switch (uname)
    case Darwin
        set bw_sock_path "$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
    case Linux
        set bw_sock_path "$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
end

# Check if the Bitwarden socket exists and is actually a socket file
if test -S "$bw_sock_path"
    set --global --export SSH_AUTH_SOCK "$bw_sock_path"
else
    echo "Error: Bitwarden SSH agent socket not found at $bw_sock_path" >&2
    echo "Please ensure Bitwarden desktop app is installed and SSH agent is enabled in settings." >&2
    return 1
end
