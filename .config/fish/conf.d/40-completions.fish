# carapace - shell completions
if status --is-interactive; and type --query carapace
    carapace _carapace | source
end
