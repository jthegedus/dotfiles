# update dotfiles repository (once per day)
if [[ $- == *i* ]]; then
    ssh-check
    update_dotfiles_repository
fi
