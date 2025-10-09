# Tree - directory tree visualization
if command -v tree &> /dev/null; then
    alias tree='tree -a -C -I .git'
fi
