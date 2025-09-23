# description: copy DIR1 to DIR2
# usage: copy DIR1 DIR2
copy() {
    local count=$#
    if [[ $count -eq 2 ]] && [[ -d "$1" ]]; then
        local from="${1%/}"  # Remove trailing slash using Bash parameter expansion
        local to="${2}"
        command cp -r "${from}" "${to}"
    else
        command cp "$@"
    fi
}