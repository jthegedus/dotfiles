function fish_neofetch
    set --local cache_file /tmp/fish_neofetch_cache
    set --local cache_age 3600

    # Colors
    set --local blue (set_color --bold blue)
    set --local cyan (set_color --bold cyan)
    set --local white (set_color --bold white)
    set --local reset (set_color normal)

    # W ASCII art
    set --local ascii_art \
        "vWv                      vWv" \
        "WWWv                    vWWW" \
        "VWWv                    vWWV" \
        "WWWv                    vWWW" \
        "WWWW         vv         WWWW" \
        "VWWW        vWWv        WWWV" \
        ":WWWv      vVWWVv      vWWW:" \
        " WWWv     vWW  WWv     vWWW " \
        " vWWv    vWWv  vWWv    vWWv " \
        "  WWWv  WWWV    VWWW  vWWW  " \
        "  :WWWvvWWW:    :WWWvvWWW:  " \
        "   VWWWWWWv      vWWWWWWV   " \
        "    :vWWWW        WWWWv:    "

    # Check cache first
    set --local info_lines
    set --local use_cached_info 0
    if test -f $cache_file
        set --local cache_time (stat --format=%Y $cache_file 2>/dev/null)
        if test -n "$cache_time"
            set --local current_time (date +%s)
            set --local age (math $current_time - $cache_time)
            if test $age -lt $cache_age
                set use_cached_info 1
                set info_lines (cat $cache_file 2>/dev/null)
            end
        end
    end

    # Generate system info if not cached
    if test $use_cached_info -eq 0
        # Get system info
        set --local username (whoami)
        set --local var_hostname (hostname)
        set --local os_info (ugrep '^PRETTY_NAME=' /etc/os-release 2>/dev/null | cut -d '"' -f 2)
        or set os_info Linux
        set --local kernel (uname --kernel-release)

        # Get uptime
        set --local uptime_seconds (cat /proc/uptime 2>/dev/null | cut -d '.' -f 1)
        or set uptime_seconds 0
        set --local uptime_hours (math $uptime_seconds / 3600)
        set --local uptime_str "$uptime_hours"h""

        # Get packages
        set --local packages Unknown
        if command --query rpm
            set packages (rpm -qa 2>/dev/null | wc -l)" (rpm)"
        end

        # Get shell
        set --local shell_info "$SHELL $version"

        # Get CPU
        set --local cpu_info (ugrep '^model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d ':' -f 2 | string trim)
        or set cpu_info "Unknown CPU"

        # Get GPU info
        set --local gpu_info
        if command --query lspci
            set --local gpu_lines (lspci 2>/dev/null | ugrep -i 'vga\|3d\|display')
            for gpu_line in $gpu_lines
                set --local raw_gpu (echo $gpu_line | cut -d ':' -f 3 | string trim)
                # Extract shorter GPU name
                if string match -q "*Radeon*" $raw_gpu
                    set --local gpu_name (echo $raw_gpu | sed 's/.*\[\([^]]*Radeon[^]]*\)\].*/\1/')
                    set gpu_info $gpu_info $gpu_name
                else if string match -q "*Raphael*" $raw_gpu
                    set gpu_info $gpu_info "AMD Raphael (integrated)"
                else
                    # Fallback: try to extract content in brackets
                    set --local bracket_content (echo $raw_gpu | sed 's/.*\[\([^]]*\)\].*/\1/')
                    if test "$bracket_content" != "$raw_gpu"
                        set gpu_info $gpu_info $bracket_content
                    else
                        set gpu_info $gpu_info $raw_gpu
                    end
                end
            end
        end

        # Fallback if no GPUs found
        if test (count $gpu_info) -eq 0
            set gpu_info Unknown
        end

        # Get memory
        set --local mem_total (ugrep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}')
        or set mem_total 0
        set --local mem_available (ugrep MemAvailable /proc/meminfo 2>/dev/null | awk '{print $2}')
        or set mem_available 0
        set --local mem_used (math $mem_total - $mem_available)
        set --local mem_total_gb (math --scale=1 $mem_total / 1048576)
        set --local mem_used_gb (math --scale=1 $mem_used / 1048576)

        # Create info lines with GPU entries
        set info_lines "$username@$var_hostname" "" "OS: $os_info" "Kernel: $kernel" "Uptime: $uptime_str" "Packages: $packages" "Shell: $shell_info" "CPU: $cpu_info"

        # Add GPU lines
        for gpu in $gpu_info
            set info_lines $info_lines "GPU: $gpu"
        end

        # Add memory line
        set info_lines $info_lines "Memory: $mem_used_gb GB / $mem_total_gb GB"

        # Save to cache
        printf '%s\n' $info_lines >$cache_file 2>/dev/null
    end

    # Display output
    for i in (seq 1 (count $ascii_art))
        set --local ascii_line "$blue$ascii_art[$i]$reset"
        set --local info_line ""

        if test $i -le (count $info_lines)
            set info_line $info_lines[$i]
            if test $i -eq 1
                set info_line "$cyan$info_line$reset"
            else if string match -q "*:*" $info_line
                set --local parts (string split ':' $info_line)
                set --local label $parts[1]
                set --local value (string join ':' $parts[2..-1])
                set info_line "$white$label$reset:$value"
            end
        end

        printf "  %-34s %s\n" $ascii_line $info_line
    end

    echo
end
