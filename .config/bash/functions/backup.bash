# description: backup a file with a .bak suffix
# usage: backup filename
backup() {
    local filename="${1}"
    cp "${filename}" "${filename}.bak"
}