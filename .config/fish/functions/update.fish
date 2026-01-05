function update --description "Update system packages via Homebrew"
    echo "--- brew update ---"
    brew update
    echo "--- brew upgrade --greedy"
    brew upgrade --greedy
end
