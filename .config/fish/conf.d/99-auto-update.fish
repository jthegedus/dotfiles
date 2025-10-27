# auto-update dotfiles repository and homebrew (once per day)
if status --is-interactive
    test "$ENABLE_SSH_CHECK" = "1"; and ssh-check
    test "$ENABLE_DOTFILES_UPDATE" = "1"; and update_dotfiles_repository
    test "$ENABLE_BREW_UPDATE" = "1"; and update_brew
end
