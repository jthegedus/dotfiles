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

    # Collect SSH keys from both local files and agent
    set -l key_contents # Full public key line
    set -l key_labels # Display label for each key
    set -l key_files # Local file path (empty string if agent-only)
    set -l local_count 0

    # Collect from local ~/.ssh/*.pub files
    for pubfile in ~/.ssh/*.pub
        if test -f "$pubfile"
            set -l content (string trim (cat $pubfile))
            set -a key_contents $content
            set -a key_labels (basename $pubfile)
            set -a key_files $pubfile
            set local_count (math $local_count + 1)
        end
    end

    # Collect agent-only keys from SSH agent (ssh-add -L)
    set -l agent_keys (ssh-add -L 2>/dev/null)
    for agent_key in $agent_keys
        set -l agent_keypart (string split ' ' $agent_key)[2]
        set -l agent_comment (string split ' ' $agent_key)[3]
        if test -z "$agent_comment"
            set agent_comment "unnamed-key"
        end

        # Check if this key already exists locally (by key content)
        set -l is_local false
        for i in (seq (count $key_contents))
            set -l existing_keypart (string split ' ' $key_contents[$i])[2]
            if test "$agent_keypart" = "$existing_keypart"
                set is_local true
                break
            end
        end

        # Only add if not already in local files
        if test "$is_local" = false
            set -a key_contents $agent_key
            set -a key_labels $agent_comment
            set -a key_files ""
        end
    end

    if test (count $key_contents) -eq 0
        echo "Error: No SSH keys found in ~/.ssh/*.pub or SSH agent" >&2
        return 1
    end

    # Display local keys
    echo "~/.ssh/*.pub keys:"
    if test $local_count -eq 0
        echo "    (none)"
    else
        for i in (seq $local_count)
            echo "    $i) $key_labels[$i]"
        end
    end
    echo ""

    # Display agent-only keys
    set -l agent_only_count (math (count $key_contents) - $local_count)
    echo "ssh-agent keys:"
    if test $agent_only_count -eq 0
        echo "    (all ssh-agent keys already in ~/.ssh)"
    else
        for i in (seq (math $local_count + 1) (count $key_contents))
            echo "    $i) $key_labels[$i]"
        end
    end
    echo ""

    # Authentication key selection
    read --prompt-str "Select authentication key (number): " auth_choice
    if not string match -qr '^\d+$' -- $auth_choice; or test $auth_choice -lt 1; or test $auth_choice -gt (count $key_contents)
        echo "Error: Invalid selection" >&2
        return 1
    end

    # Handle auth key - ensure we have a local file
    if test -n "$key_files[$auth_choice]"
        # Key has a local file
        set --global __git_ssh_identity (basename $key_files[$auth_choice] .pub)
    else
        # Agent-only key - write to ~/.ssh/
        set -l agent_comment (string split ' ' $key_contents[$auth_choice])[3]
        if test -z "$agent_comment"
            set agent_comment "agent-key-"(date +%s)
        end
        # Sanitize filename
        set -l filename (string replace -ra '[^a-zA-Z0-9@._-]' '-' $agent_comment)
        set -l filepath ~/.ssh/$filename.pub
        echo $key_contents[$auth_choice] >$filepath
        chmod 644 $filepath
        echo "Wrote agent key to $filepath"
        set --global __git_ssh_identity $filename
    end

    # Signing key selection
    read --prompt-str "Select signing key (number): " signing_choice
    if not string match -qr '^\d+$' -- $signing_choice; or test $signing_choice -lt 1; or test $signing_choice -gt (count $key_contents)
        echo "Error: Invalid selection" >&2
        return 1
    end
    set --global __git_signingkey $key_contents[$signing_choice]

    if test -z "$__git_name" -o -z "$__git_email"
        echo "Error: name and email are required" >&2
        return 1
    end

    return 0
end
