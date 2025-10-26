# Updates Homebrew formulae and casks once per day
function update_brew
    argparse h/help -- $argv
    or return

    if set --query _flag_help
        echo "Usage: update_brew"
        echo "Updates Homebrew formulae and casks once per day"
        return
    end

    set --local check_dir (set --query TMPDIR; and echo $TMPDIR; or echo /tmp)
    set --local timestamp_file $check_dir/.brew_update_(date +%Y-%m-%d)

    test -f $timestamp_file
    and return

    echo "Updating Homebrew..."

    if brew update >/dev/null 2>&1; and brew upgrade --greedy >/dev/null 2>&1
        touch $timestamp_file
    else
        echo "Warning: Homebrew update/upgrade failed. Please check manually." >&2
        return 1
    end
end
