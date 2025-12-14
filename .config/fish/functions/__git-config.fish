function __git-config --description "Apply git identity configuration to current repo"
    argparse 'skip-remote' -- $argv

    # Apply required config
    git config --local user.name "$__git_name"
    or return 1

    git config --local user.email "$__git_email"
    or return 1

    # Apply signing key if provided
    if test -n "$__git_signingkey"
        git config --local user.signingkey "$__git_signingkey"
    end

    # Configure SSH identity if provided
    if test -n "$__git_ssh_identity" -a -n "$__git_ssh_pubkey"
        if not test -d ~/.ssh
            echo "Error: ~/.ssh directory does not exist" >&2
            return 1
        end

        echo "$__git_ssh_pubkey" >~/.ssh/$__git_ssh_identity.pub
        chmod 600 ~/.ssh/$__git_ssh_identity.pub

        git config --local core.sshCommand "ssh -i ~/.ssh/$__git_ssh_identity.pub -o IdentitiesOnly=yes"

        echo "SSH identity configured: ~/.ssh/$__git_ssh_identity.pub"
    end

    # Configure remote URL if provided and not skipped
    if not set -q _flag_skip_remote
        if test -n "$__git_remote_url"
            if git remote get-url origin >/dev/null 2>&1
                git remote set-url origin "$__git_remote_url"
            else
                git remote add origin "$__git_remote_url"
            end
        end
    end

    # Clean up global variables
    set -e __git_name __git_email __git_signingkey __git_ssh_identity __git_ssh_pubkey __git_remote_url

    return 0
end
