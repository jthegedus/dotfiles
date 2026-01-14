function git-clone --description "Clone repository with user configuration"
    if test (count $argv) -lt 1
        echo "Usage: git-clone <remote-url> [destination]" >&2
        return 1
    end

    set -l remote_url $argv[1]
    set -l destination $argv[2]

    # Determine destination directory name
    if test -z "$destination"
        # Extract repo name from URL (handles both HTTPS and SSH formats)
        set destination (string replace -r '.*[:/]([^/]+?)(?:\.git)?$' '$1' $remote_url)
    end

    __git-prompt --skip-remote
    or return 1

    # Clone with SSH identity if provided
    if test -n "$__git_ssh_identity"
        # Clone with custom SSH command using selected key (public key triggers BitWarden SSH Agent lookup)
        GIT_SSH_COMMAND="ssh -i ~/.ssh/$__git_ssh_identity.pub -o IdentitiesOnly=yes" \
            git clone $remote_url $destination
        or return 1
    else
        git clone $remote_url $destination
        or return 1
    end

    cd $destination
    or return 1

    __git-config --skip-remote
    or return 1
end
