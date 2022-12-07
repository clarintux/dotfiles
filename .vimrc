"  _          _       _              _                    
" | |   _   _(_) __ _(_)___   __   _(_)_ __ ___  _ __ ___ 
" | |  | | | | |/ _` | / __|  \ \ / / | '_ ` _ \| '__/ __|
" | |__| |_| | | (_| | \__ \   \ V /| | | | | | | | | (__ 
" |_____\__,_|_|\__, |_|___/  (_)_/ |_|_| |_| |_|_|  \___|
"               |___/                                     
" 
" My vim config.. 

set nocompatible
filetype plugin indent on
syntax enable
set encoding=utf-8
set hidden
set ruler
set number relativenumber
set mouse=a
set ignorecase
set smartcase
set ai
set si
set wildmenu
set wildmode=longest,list,full
set laststatus=2
set confirm
let mapleader = " "
set showmatch
set incsearch
set hlsearch
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set lazyredraw
set magic
set showmatch
set t_Co=256
let g:rehash256=1
let g:gruvbox_termcolors=256
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
set background=dark
hi Normal guibg=NONE ctermbg=NONE
let g:airline_powerline_fonts=1

au BufRead /tmp/neomutt-* set tw=72

autocmd BufRead,BufNewFile /tmp/calcurse* set filetype=markdown
autocmd BufRead,BufNewFile ~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile *.txt set filetype=plaintext
autocmd BufRead,BufNewFile /tmp/neomutt-* set filetype=plaintext
autocmd FileType plaintext setlocal spell spelllang=de,it

map <silent> <leader><cr> :noh<cr>
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
