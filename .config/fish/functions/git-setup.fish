function git-setup --description "Initialize git repository with user configuration"
    # Initialize git repository only if not already initialized
    if not git rev-parse --git-dir >/dev/null 2>&1
        git init
        or return 1
    end

    __git-prompt
    or return 1

    __git-config
    or return 1
end
