# carapace - shell completions
if status --is-interactive; and type --query carapace
    set --universal --export CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
    carapace _carapace | source
end
