# LLA jump function - quick directory navigation
# Usage: j [bookmark-name]
function j --description "Jump to frequently used directories using lla"
    set dir (lla jump)
    if test -n "$dir" -a -d "$dir"
        cd "$dir"
    end
end
