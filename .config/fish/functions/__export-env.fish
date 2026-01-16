# Export environment variables from a file
function __export-env --description "Export environment variables from a file"
    set --local label $argv[1]
    set --local env_file $argv[2]
    set --local loaded_keys
    set --local skipped_keys

    if not test -f $env_file
        echo "✗ $label: $env_file (not found)"
        return
    end

    while read --local line
        # Skip empty lines and comments
        if string match --quiet --regex "^\\s*#" -- "$line"; or string match --quiet --regex "^\\s*\$" -- "$line"
            continue
        end
        if string match --quiet "*=*" -- "$line"
            set --local key_value (string split --max 1 "=" -- "$line")
            if test (count $key_value) -eq 2
                if test -n "$key_value[2]"
                    set --global --export $key_value[1] $key_value[2]
                    set --append loaded_keys $key_value[1]
                else
                    set --append skipped_keys $key_value[1]
                end
            end
        end
    end <$env_file

    echo "✓ $label: $env_file ("(count $loaded_keys)" vars)"
    if test (count $skipped_keys) -gt 0
        echo "  Skipped (empty value): "(string join ", " $skipped_keys)
    end
end
