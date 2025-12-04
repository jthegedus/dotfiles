function toybox --description "Run command via toybox, fallback to system"
    # Initialize availability check (once per session)
    if not set -q __toybox_available
        if not command -q docker
            set -g __toybox_available 0
            set -g __toybox_reason "docker not found"
            echo "Toybox: docker not installed" >&2
        else if not docker info &>/dev/null
            set -g __toybox_available 0
            set -g __toybox_reason "docker daemon not running"
            echo "Toybox: docker daemon not running" >&2
        else if not docker images -q tianon/toybox:latest 2>/dev/null | string length -q
            set -g __toybox_available 0
            set -g __toybox_reason "image missing"
            echo "Toybox: run 'docker pull tianon/toybox:latest' to enable" >&2
        else
            set -g __toybox_available 1
            # Cache available commands
            set -g __toybox_commands (docker run --rm tianon/toybox:latest toybox 2>/dev/null | string split ' ')
        end
    end

    set -l cmd $argv[1]
    set -l args $argv[2..-1]

    # Check if toybox is available and has this command
    # Fall back to system when at root (Docker can't mount / as destination)
    if test "$__toybox_available" = "1"; and contains -- $cmd $__toybox_commands; and test "$PWD" != "/"
        docker run --rm \
            --user (id -u):(id -g) \
            --volume "$PWD:$PWD" \
            --workdir "$PWD" \
            --volume "$HOME:$HOME" \
            tianon/toybox:latest \
            $cmd $args
    else
        command $cmd $args
    end
end
