function fish_greeting
    if status is-interactive; and test "$ENABLE_SSH_CHECK" = 1
        __ssh-check
    end
end
