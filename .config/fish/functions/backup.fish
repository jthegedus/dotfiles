# description: backup a file with a .bak suffix
# usage: backup filename
function backup --argument filename
    cp $filename $filename.bak
end
