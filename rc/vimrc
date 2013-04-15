"my ~/.vimrc config
"

set nocompatible                  " Must come first because it changes other options.
set formatoptions-=cro            " Turn AutoComment on next line
set modeline

call pathogen#infect()            " Giving life to Pathogen for Runtime Path Manipulation
" call pathogen#infect('acustom')            " Pathogen's Runtime Path Manipulation from custom dir
syntax enable                     " Turn on syntax highlighting.
filetype plugin indent on         " Turn on file type detection.

set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.

set backspace=indent,eol,start    " Intuitive backspacing.

set hidden                        " Handle multiple buffers better.

set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.

set number                        " Show line numbers.
set ruler                         " Show cursor position.

set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.

set title                         " Set the terminal's title

set visualbell                    " No beeping.

set tabstop=2                    " Global tab width.
set softtabstop=2                    " Global tab width.
set shiftwidth=2                 " And again, related.
set expandtab                    " Use spaces instead of tabs

colorscheme chocolateliquor      " could type ':color <_TAB_>' to weigh options
highlight LiteralTabs ctermbg=darkgreen guibg=darkgreen
match LiteralTabs /\s\  /        " Actual TABS
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/    " Trailing Spaces

au BufRead,BufNewFile *.pp       set filetype=puppet

autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufRead *.py set nocindent
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

autocmd FileType ruby setlocal foldmethod=syntax
autocmd FileType css  setlocal foldmethod=indent shiftwidth=2 tabstop=2

command! FRB set filetype=ruby
command! FPY set filetype=python
