function backup --argument filename --description "Backup (copy) a file with .bak suffix"
    cp $filename $filename.bak
end
