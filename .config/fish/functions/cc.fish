# Claude Code wrapper which sets Environment Variables for MCPs from .env.mcp.secrets
function cc --description "Claude Code with Secrets: Run claude command with environment variables from .env.mcp.secrets"
    # Load global secrets first, then local secrets (local overrides global)
    __export-env "Global secrets" $HOME/.agents/.env.mcp.secrets
    __export-env "Local secrets" $PWD/.env.mcp.secrets
    command claude $argv
end
