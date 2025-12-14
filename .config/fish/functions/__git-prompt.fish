function __git-prompt --description "Prompt for git identity information"
    argparse 'skip-remote' -- $argv

    read --prompt-str "Git user.name (GitHub/Lab username): " --global __git_name
    read --prompt-str "Git user.email (GitHub/Lab email): " --global __git_email
    read --prompt-str "Signing SSH Key - public key value (ssh-ed25519 <HASH>): " --global __git_signingkey
    read --prompt-str "Authentication SSH Key - identity name (e.g: auth_github_username): " --global __git_ssh_identity
    read --prompt-str "Authentication SSH Key - public key value (ssh-ed25519 <HASH> [comment]): " --global __git_ssh_pubkey

    if not set -q _flag_skip_remote
        read --prompt-str "Remote URL (git@github.com:OWNER/REPOSITORY.git): " --global __git_remote_url
    end

    if test -z "$__git_name" -o -z "$__git_email"
        echo "Error: name and email are required" >&2
        return 1
    end

    return 0
end
