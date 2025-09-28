# Updates the dotfiles repository once per day on terminal session start
update_dotfiles_repository() {
    local OPTIND OPTARG flag_help

    while getopts "h" flag; do
        case "$flag" in
            h) flag_help=1;;
            *) return 1;;
        esac
    done

    if [[ -n "$flag_help" ]]; then
        echo "Usage: update_dotfiles_repository"
        echo "Updates dotfiles repository once per day"
        echo "Auto-detects repository location based on this function file's location"
        return 0
    fi

    # Auto-detect repository location by finding where this function is defined
    local func_file
    func_file="$(readlink -f "${BASH_SOURCE[0]}")"
    local func_dir
    func_dir="$(dirname "$func_file")"

    # Navigate to function directory and find git repository root
    local repo_root
    repo_root="$(cd "$func_dir" && git rev-parse --show-toplevel 2>/dev/null)"

    if [[ -z "$repo_root" ]]; then
        echo "Error: Could not find git repository from function location: $func_dir" >&2
        return 1
    fi

    local git_dir="$repo_root/.git"
    local work_tree="$repo_root"
    local check_dir="${TMPDIR:-/tmp}"
    local timestamp_file="$check_dir/.dotfiles_pull_$(date +%Y-%m-%d)"

    [[ -f "$timestamp_file" ]] && return 0

    if ! git --git-dir="$git_dir" --work-tree="$work_tree" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Warning: dotfiles repo not found at $work_tree" >&2
        return 1
    fi

    echo "Checking for dotfiles updates..."

    # Check SSH agent configuration before attempting git pull
    if ! ssh-check >/dev/null 2>&1; then
        echo ""
        echo "SSH agent check failed. Running diagnostics:"
        ssh-check
        echo ""
        echo "Please fix SSH issues before dotfiles can be updated."
        echo "Run 'ssh-check' anytime to see diagnostics."
        return 1
    fi

    if git --git-dir="$git_dir" --work-tree="$work_tree" pull; then
        touch "$timestamp_file"
    else
        echo "Warning: Dotfiles pull failed. Please check manually." >&2
    fi
}