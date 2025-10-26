function git-setup() {
    local name email signingkey ssh_identity ssh_pubkey remote_url

    read -p "Git user.name (GitHub/Lab username): " name
    read -p "Git user.email (GitHub/Lab username): " email
    read -p "Git signing key (ssh-ed25519 <HASH>): " signingkey
    read -p "SSH identity name (e.g., github_username): " ssh_identity
    read -p "SSH public key (ssh-ed25519 <HASH> [comment]): " ssh_pubkey
    read -p "Remote URL (git@github.com:OWNER/REPOSITORY.git): " remote_url

    if [[ -z "$name" || -z "$email" ]]; then
        echo "Error: name and email are required" >&2
        return 1
    fi

    # Initialize git repository only if not already initialized
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        git init || return 1
    fi

    git config --local user.name "$name" && \
    git config --local user.email "$email"

    if [[ -n "$signingkey" ]]; then
        git config --local user.signingkey "$signingkey"
    fi

    # Configure SSH identity if provided
    if [[ -n "$ssh_identity" && -n "$ssh_pubkey" ]]; then
        # Check if ~/.ssh directory exists
        if [[ ! -d ~/.ssh ]]; then
            echo "Error: ~/.ssh directory does not exist" >&2
            return 1
        fi

        # Save public key to file
        echo "$ssh_pubkey" > ~/.ssh/"$ssh_identity.pub"
        chmod 600 ~/.ssh/"$ssh_identity.pub"

        # Configure git to use this SSH key
        git config --local core.sshCommand "ssh -i ~/.ssh/$ssh_identity.pub -o IdentitiesOnly=yes"

        echo "SSH identity configured: ~/.ssh/$ssh_identity.pub"
    fi

    # Configure remote URL if provided
    if [[ -n "$remote_url" ]]; then
        if git remote get-url origin >/dev/null 2>&1; then
            git remote set-url origin "$remote_url"
        else
            git remote add origin "$remote_url"
        fi
    fi
}