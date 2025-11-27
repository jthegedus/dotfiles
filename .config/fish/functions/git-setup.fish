function git-setup --description "Initialize git repository with user configuration"
    read --prompt-str "Git user.name (GitHub/Lab username): " --local name
    read --prompt-str "Git user.email (GitHub/Lab email): " --local email
    read --prompt-str "Signing SSH Key - public key value (ssh-ed25519 <HASH>): " --local signingkey
    read --prompt-str "Authentication SSH Key - identity name (e.g: auth_github_username): " --local ssh_identity
    read --prompt-str "Authentication SSH Key - public key value (ssh-ed25519 <HASH> [comment]): " --local ssh_pubkey
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
        echo "$ssh_pubkey" >~/.ssh/$ssh_identity.pub
        chmod 600 ~/.ssh/$ssh_identity.pub

        # Configure git to use this SSH key
        git config --local core.sshCommand "ssh -v -i ~/.ssh/$ssh_identity.pub -o IdentitiesOnly=yes"

        echo "SSH identity configured: ~/.ssh/$ssh_identity.pub"
    end

    # Configure remote URL if provided
    if test -n "$remote_url"
        if git remote get-url origin >/dev/null 2>&1
            git remote set-url origin "$remote_url"
        else
            git remote add origin "$remote_url"
        end
    end
end
