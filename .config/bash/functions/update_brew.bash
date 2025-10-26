# Updates Homebrew formulae and casks once per day
update_brew() {
    local OPTIND OPTARG flag_help

    while getopts "h" flag; do
        case "$flag" in
            h) flag_help=1;;
            *) return 1;;
        esac
    done

    if [[ -n "$flag_help" ]]; then
        echo "Usage: update_brew"
        echo "Updates Homebrew formulae and casks once per day"
        return 0
    fi

    local check_dir="${TMPDIR:-/tmp}"
    local timestamp_file="$check_dir/.brew_update_$(date +%Y-%m-%d)"

    [[ -f "$timestamp_file" ]] && return 0

    echo "Updating Homebrew..."

    if brew update >/dev/null 2>&1 && brew upgrade --greedy >/dev/null 2>&1; then
        touch "$timestamp_file"
    else
        echo "Warning: Homebrew update/upgrade failed. Please check manually." >&2
        return 1
    fi
}
