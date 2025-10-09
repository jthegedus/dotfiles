function git-setup --description "Initialize git repository with user configuration"
    read --prompt-str "Git user.name (GitHub/Lab username): " --local name
    read --prompt-str "Git user.email (GitHub/Lab username): " --local email
    read --prompt-str "Git signing key (ssh-ed25519 <HASH>): " --local signingkey
    read --prompt-str "SSH identity name (e.g., github_username): " --local ssh_identity
    read --prompt-str "SSH public key (ssh-ed25519 <HASH> [comment]): " --local ssh_pubkey
    read --prompt-str "Remote URL (git@github.com:OWNER/REPOSITORY.git): " --local remote_url

    test -n "$name" -a -n "$email"
    or begin
        echo "Error: name and email are required" >&2
        return 1
    end

    # Initialize git repository only if not already initialized
    if not git rev-parse --git-dir >/dev/null 2>&1
        git init
        or return 1
    end

    git config --local user.name "$name"
    and git config --local user.email "$email"
    and test -n "$signingkey"; and git config --local user.signingkey "$signingkey"

    # Configure SSH identity if provided
    if test -n "$ssh_identity" -a -n "$ssh_pubkey"
        # Check if ~/.ssh directory exists
        if not test -d ~/.ssh
            echo "Error: ~/.ssh directory does not exist" >&2
            return 1
        end

        # Save public key to file
        echo "$ssh_pubkey" > ~/.ssh/$ssh_identity.pub
        chmod 600 ~/.ssh/$ssh_identity.pub

        # Configure git to use this SSH key
        git config --local core.sshCommand "ssh -i ~/.ssh/$ssh_identity.pub -o IdentitiesOnly=yes"

        echo "SSH identity configured: ~/.ssh/$ssh_identity.pub"
    end

    test -n "$remote_url"; and git remote add origin "$remote_url"
end
