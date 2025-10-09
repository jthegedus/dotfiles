# LLA jump function - quick directory navigation
# Usage: j [bookmark-name]
j() {
    local dir=$(lla jump)
    if [ -n "$dir" ] && [ -d "$dir" ]; then
        cd "$dir"
    fi
}
