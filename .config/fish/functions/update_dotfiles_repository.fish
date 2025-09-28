# Updates the dotfiles repository once per day on terminal session start
function update_dotfiles_repository
    argparse h/help -- $argv
    or return

    if set --query _flag_help
        echo "Usage: update_dotfiles_repository"
        echo "Updates dotfiles repository once per day"
        echo "Auto-detects repository location based on this function file's location"
        return
    end

    # Auto-detect repository location by finding where this function is defined
    set --local func_file (functions --details update_dotfiles_repository)
    set --local real_path (realpath $func_file)
    set --local func_dir (dirname $real_path)

    # Navigate to function directory and find git repository root
    set --local repo_root (git -C $func_dir rev-parse --show-toplevel 2>/dev/null)

    if test -z "$repo_root"
        echo "Error: Could not find git repository from function location: $func_dir" >&2
        return 1
    end

    set --local git_dir $repo_root/.git
    set --local work_tree $repo_root
    set --local check_dir (set --query TMPDIR; and echo $TMPDIR; or echo /tmp)
    set --local timestamp_file $check_dir/.dotfiles_pull_(date +%Y-%m-%d)

    test -f $timestamp_file
    and return

    git --git-dir=$git_dir --work-tree=$work_tree rev-parse --is-inside-work-tree >/dev/null 2>&1
    or begin
        echo "Warning: dotfiles repo not found at $work_tree" >&2
        return 1
    end

    echo "Checking for dotfiles updates..."

    # Check SSH agent configuration before attempting git pull
    if not ssh-check >/dev/null 2>&1
        echo ""
        echo "SSH agent check failed. Running diagnostics:"
        ssh-check
        echo ""
        echo "Please fix SSH issues before dotfiles can be updated."
        echo "Run 'ssh-check' anytime to see diagnostics."
        return 1
    end

    git --git-dir=$git_dir --work-tree=$work_tree pull
    and touch $timestamp_file
    or echo "Warning: Dotfiles pull failed. Please check manually." >&2
end
