function ssh-check() {
    local has_error=0

    # 1. Check SSH_AUTH_SOCK environment variable
    if [[ -z "${SSH_AUTH_SOCK}" ]]; then
        echo "❌ SSH_AUTH_SOCK is not set" >&2
        echo "   The SSH agent is not configured." >&2
        has_error=1
    elif [[ ! -S "${SSH_AUTH_SOCK}" ]]; then
        echo "❌ SSH_AUTH_SOCK points to invalid socket: ${SSH_AUTH_SOCK}" >&2
        echo "   The SSH agent socket does not exist or is not valid." >&2
        echo "   → Action: Ensure Bitwarden desktop is running and SSH agent is enabled in settings" >&2
        echo "   → Action: Check if Bitwarden is installed at the expected location" >&2
        has_error=1
    else
        echo "✅ SSH agent socket found at: ${SSH_AUTH_SOCK}"
    fi

    # 2. Check if agent is responsive and has keys
    if [[ $has_error -eq 0 ]]; then
        if ! ssh-add -l &>/dev/null; then
            local exit_code=$?
            if [[ $exit_code -eq 2 ]]; then
                echo "❌ SSH agent is not responding" >&2
                echo "   The agent socket exists but is not accepting connections." >&2
                echo "   → Action: Restart Bitwarden desktop application" >&2
                echo "   → Action: Ensure Bitwarden SSH agent is enabled in Settings → SSH Agent" >&2
                has_error=1
            elif [[ $exit_code -eq 1 ]]; then
                echo "⚠️  No SSH keys loaded in agent" >&2
                echo "   The agent is running but has no identities." >&2
                echo "   → Action: Unlock your Bitwarden vault (the desktop app must be unlocked)" >&2
                echo "   → Action: Ensure SSH keys are stored in Bitwarden and have 'SSH agent' enabled" >&2
                echo "   → Action: Check Bitwarden Settings → SSH Agent → Show SSH keys" >&2
                has_error=1
            fi
        else
            local key_count=$(ssh-add -l | wc -l)
            echo "✅ SSH agent is responding with ${key_count} key(s) loaded"
        fi
    fi

    # Final summary
    echo ""
    if [[ $has_error -eq 0 ]]; then
        echo "✅ SSH agent is properly configured and ready for use"
        echo "   You should be able to perform Git operations requiring SSH authentication"
        return 0
    else
        echo "❌ SSH agent configuration needs attention"
        echo "   Git operations requiring SSH authentication will fail until resolved"
        return 1
    fi
}
