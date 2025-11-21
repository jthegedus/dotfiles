# auto-update dotfiles repository and homebrew (once per day)
if [[ $- == *i* ]] && [[ -z "${VSCODE_RESOLVING_ENVIRONMENT}" ]]; then
    [[ "$ENABLE_SSH_CHECK" == "1" ]] && ssh-check
    [[ "$ENABLE_DOTFILES_UPDATE" == "1" ]] && update_dotfiles_repository
    [[ "$ENABLE_BREW_UPDATE" == "1" ]] && update_brew
fi
