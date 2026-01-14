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

    # Configure SSH identity if provided (public key triggers BitWarden SSH Agent lookup)
    if test -n "$__git_ssh_identity"
        git config --local core.sshCommand "ssh -i ~/.ssh/$__git_ssh_identity.pub -o IdentitiesOnly=yes"
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
    set -e __git_name __git_email __git_signingkey __git_ssh_identity __git_remote_url

    return 0
end
