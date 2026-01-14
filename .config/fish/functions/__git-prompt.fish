function __git-prompt --description "Prompt for git identity information"
    argparse 'skip-remote' -- $argv

    # Get current git config values
    set -l current_name (git config user.name 2>/dev/null)
    set -l current_email (git config user.email 2>/dev/null)
    set -l current_remote (git remote get-url origin 2>/dev/null)

    # Remote URL (first, unless skipped)
    if not set -q _flag_skip_remote
        if test -n "$current_remote"
            read --prompt-str "remote.origin.url ($current_remote): " __git_remote_input
        else
            read --prompt-str "remote.origin.url (git@github.com:OWNER/REPOSITORY.git): " __git_remote_input
        end
        if test -n "$__git_remote_input"
            set --global __git_remote_url $__git_remote_input
        else if test -n "$current_remote"
            set --global __git_remote_url $current_remote
        end
    end

    # User name
    if test -n "$current_name"
        read --prompt-str "user.name ($current_name): " __git_name_input
    else
        read --prompt-str "user.name: " __git_name_input
    end
    if test -n "$__git_name_input"
        set --global __git_name $__git_name_input
    else if test -n "$current_name"
        set --global __git_name $current_name
    end

    # User email
    if test -n "$current_email"
        read --prompt-str "user.email ($current_email): " __git_email_input
    else
        read --prompt-str "user.email: " __git_email_input
    end
    if test -n "$__git_email_input"
        set --global __git_email $__git_email_input
    else if test -n "$current_email"
        set --global __git_email $current_email
    end

    # List available SSH public keys
    set -l ssh_keys ~/.ssh/*.pub
    if test (count $ssh_keys) -eq 0
        echo "Error: No .pub files found in ~/.ssh" >&2
        return 1
    end

    echo "Available SSH keys:"
    for i in (seq (count $ssh_keys))
        echo "  $i) "(basename $ssh_keys[$i])
    end
    echo ""

    # Authentication key selection
    read --prompt-str "Select authentication key (number): " auth_choice
    if not string match -qr '^\d+$' -- $auth_choice; or test $auth_choice -lt 1; or test $auth_choice -gt (count $ssh_keys)
        echo "Error: Invalid selection" >&2
        return 1
    end
    set -l auth_file $ssh_keys[$auth_choice]
    set --global __git_ssh_identity (basename $auth_file .pub)

    # Signing key selection
    read --prompt-str "Select signing key (number): " signing_choice
    if not string match -qr '^\d+$' -- $signing_choice; or test $signing_choice -lt 1; or test $signing_choice -gt (count $ssh_keys)
        echo "Error: Invalid selection" >&2
        return 1
    end
    set -l signing_file $ssh_keys[$signing_choice]
    set --global __git_signingkey (string trim (cat $signing_file))

    if test -z "$__git_name" -o -z "$__git_email"
        echo "Error: name and email are required" >&2
        return 1
    end

    return 0
end
