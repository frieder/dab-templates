" vim configuration
" Examples taken from
"  - https://gist.github.com/simonista/8703722
"  - http://vim.wikia.com/wiki/Example_vimrc
"

" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" Turn on syntax highlighting
syntax on
"set background=dark

" For plugins to load correctly
filetype plugin indent on

" Show line numbers
"set number

" Encoding
set encoding=utf-8

" Whitespace and line wrap
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Disable visual mode (default in e.g. Debian 9) as it may not work properly
" with PuTTY & right click paste
set mouse-=a

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm
