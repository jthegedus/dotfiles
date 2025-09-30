# update dotfiles repository (once per day)
if status --is-interactive
    ssh-check
    update_dotfiles_repository
end
