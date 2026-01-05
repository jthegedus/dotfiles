# Export environment variables from a file
function __export-env --description "Export environment variables from a file"
    set --local env_file $argv[1]
    set --local loaded_keys
    set --local skipped_keys

    if test -f $env_file
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

        if test (count $loaded_keys) -gt 0 -o (count $skipped_keys) -gt 0
            echo "Loading environment variables from $env_file:"
            if test (count $loaded_keys) -gt 0
                echo (count $loaded_keys)" Loaded: "(string join ", " $loaded_keys)
            end
            if test (count $skipped_keys) -gt 0
                echo (count $skipped_keys)" Skipped: "(string join ", " $skipped_keys)
            end
        end
    end
end
