function ssh-check --description "Check SSH agent status and provide diagnostics"
    set --local has_error 0

    # 1. Check SSH_AUTH_SOCK environment variable
    if not set --query SSH_AUTH_SOCK
        echo "❌ SSH_AUTH_SOCK is not set" >&2
        echo "   The SSH agent is not configured." >&2
        set has_error 1
    else if not test -S "$SSH_AUTH_SOCK"
        echo "❌ SSH_AUTH_SOCK points to invalid socket: $SSH_AUTH_SOCK" >&2
        echo "   The SSH agent socket does not exist or is not valid." >&2
        echo "   → Action: Ensure Bitwarden desktop is running and SSH agent is enabled in settings" >&2
        echo "   → Action: Check if Bitwarden is installed at the expected location" >&2
        set has_error 1
    else
        echo "✅ SSH agent socket found at: $SSH_AUTH_SOCK"
    end

    # 2. Check if agent is responsive and has keys
    if test $has_error -eq 0
        if not ssh-add -l &>/dev/null
            set --local exit_code $status
            if test $exit_code -eq 2
                echo "❌ SSH agent is not responding" >&2
                echo "   The agent socket exists but is not accepting connections." >&2
                echo "   → Action: Restart Bitwarden desktop application" >&2
                echo "   → Action: Ensure Bitwarden SSH agent is enabled in Settings → SSH Agent" >&2
                set has_error 1
            else if test $exit_code -eq 1
                echo "⚠️ No SSH keys loaded in agent" >&2
                echo "   The agent is running but has no identities." >&2
                echo "   → Action: Unlock your Bitwarden vault (the desktop app must be unlocked)" >&2
                echo "   → Action: Ensure SSH keys are stored in Bitwarden and have 'SSH agent' enabled" >&2
                echo "   → Action: Check Bitwarden Settings → SSH Agent → Show SSH keys" >&2
                set has_error 1
            end
        else
            set --local key_count (ssh-add -l | wc -l)
            echo "✅ SSH agent is responding with $key_count key(s) loaded"
        end
    end

    # Final summary
    if test $has_error -eq 0
        echo "✅ SSH agent is properly configured and ready for use"
        echo "   You should be able to perform Git operations requiring SSH authentication"
        return 0
    else
        echo "❌ SSH agent configuration needs attention"
        echo "   Git operations requiring SSH authentication will fail until resolved"
        return 1
    end
end
