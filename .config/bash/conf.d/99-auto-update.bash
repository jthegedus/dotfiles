# auto-update dotfiles repository and homebrew (once per day)
if [[ $- == *i* ]]; then
    ssh-check
    update_dotfiles_repository
    update_brew
fi
