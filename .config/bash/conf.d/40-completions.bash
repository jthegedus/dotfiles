# carapace - shell completions
if [[ $- == *i* ]] && command -v carapace >/dev/null 2>&1; then
    export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
    source <(carapace _carapace)
fi