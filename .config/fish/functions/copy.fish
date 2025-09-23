# description: copy DIR1 to DIR2
# usage: copy DIR1 DIR2
function copy
    set count (count $argv | tr --delete \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | string trim --right --chars=/)
        set to (echo $argv[2])
        command cp --recursive $from $to
    else
        command cp $argv
    end
end
