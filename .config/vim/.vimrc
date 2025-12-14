" Turn on syntax highlighting, line numbers, auto indent, smart indent, wrap lines, smart tabs, wildmenu, ignore case while searching, smart case, highlight search, move to search, regex magic, show matching brackets, and spaces instead of tabs
set nu rnu ai si wrap smarttab wildmenu ignorecase smartcase hlsearch incsearch magic showmatch expandtab
syntax on
colorscheme gruvbox
set background=dark

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Set regular expression engine automatically
set regexpengine=0

" Enable filetype plugins
"filetype plugin on
"filetype indent on

" Set to autoread when a file is changed from the outside
set autoread
au FocusGained,BufEnter * silent! checktime

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" :Y yanks the line to clipboard
command! Y normal! "*Y

" Set x lines to the cursor - when moving vertically using j/k
set so=5

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif
