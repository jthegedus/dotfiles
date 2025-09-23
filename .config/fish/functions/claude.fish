# Claude Code wrapper which sets Environment Variables for MCPs from .env.mcp.secrets
function ccs --description "Claude Code with Secrets: Run claude command with environment variables from .env.mcp.secrets"
    set --local var_count 0

    if test --file .env.mcp.secrets
        while read --local line
            if string match --quiet "*=*" -- "$line"
                set --local key_value (string split --max 1 "=" -- "$line")
                if test (count $key_value) --eq 2
                    set --export $key_value[1] $key_value[2]
                    set var_count (math $var_count + 1)
                end
            end
        end <.env.mcp.secrets

        if test $var_count --gt 0
            echo "Loaded $var_count environment variables from .env.mcp.secrets"
        end
    end

    command claude $argv
end
