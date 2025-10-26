# auto-update dotfiles repository and homebrew (once per day)
if status --is-interactive
    ssh-check
    update_dotfiles_repository
    update_brew
end
