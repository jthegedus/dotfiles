use std/util "path add"

let system_kernel_name = (uname | get kernel-name | str trim)
let bw_sock_path = match $system_kernel_name {
    "Darwin" => ($env.HOME | path join "/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"),
    "Linux" => ($env.HOME | path join "/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"),
    _ => $env.SSH_AUTH_SOCK
}
let homebrew_path = match $system_kernel_name {
    "Darwin" => "/opt/homebrew/bin",
    "Linux" => "/home/linuxbrew/.linuxbrew/bin",
    _ => "Homebrew not setup for this OS"
}

# Set Environment Variables
#   * XDG_CONFIG_HOME to ~/.config
#   * TMP_DIR to /tmp
#   * SSH_AUTH_SOCK to Bitwarden socket path
load-env {
    "XDG_CONFIG_HOME": ($env.HOME | path join ".config"),
    "TMP_DIR": "/tmp",
    "SSH_AUTH_SOCK": $bw_sock_path,
}

# Update PATH
#   * Homebrew
path add $homebrew_path

# carapace - shell completions
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ($env.HOME | path join ".cache/carapace")
carapace _carapace nushell | save --force ($env.HOME | path join ".cache/carapace/init.nu")
