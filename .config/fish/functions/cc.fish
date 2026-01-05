# Claude Code wrapper which sets Environment Variables for MCPs from .env.mcp.secrets
function cc --description "Claude Code with Secrets: Run claude command with environment variables from .env.mcp.secrets"
    __export-env .env.mcp.secrets
    command claude $argv
end
