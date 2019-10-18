" Vim Plug

" Auto install if missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'junegunn/vim-plug'
Plug 'mattn/emmet-vim'
Plug 'godlygeek/tabular'
Plug 'Chiel92/vim-autoformat'
Plug 'altercation/vim-colors-solarized'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-sleuth'
Plug 'prettier/vim-prettier'
Plug 'derekwyatt/vim-scala'
Plug 'scrooloose/nerdtree'
Plug 'ntpeters/vim-better-whitespace'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'digitaltoad/vim-pug'
Plug 'townk/vim-autoclose'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'ervandew/supertab'
Plug 'mileszs/ack.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-clojure-highlight'
call plug#end()

" Destroy arrow keys in insert mode
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" Make arrow keys useful
noremap <Up> ddkP
noremap <Down> ddp
noremap <Left> <<
noremap <Right> >>
vmap <Left> <gv
vmap <Right> >gv

" Remap splits for ease of use
noremap <C-H> <C-W><C-H>
noremap <C-J> <C-W><C-J>
noremap <C-K> <C-W><C-K>
noremap <C-L> <C-W><C-L>

noremap <F2> :NERDTreeToggle <Enter>
noremap <F8> :!rspec % <Enter>
noremap <S-F8> :!! <Enter>

" Make backspace work
set backspace=2

" Indent if already indented
set autoindent

" auto indent on these words
set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" Wrapping and tabs.
set tw=80 ts=4 sw=4 sta et sts=4 ai fo+=t

" Line numbers
set number

" PLEASE STOP BEEPING OMG
set visualbell
set t_vb=

" Keep 5 line padding on cursor
set scrolloff=5

" keyword highlighting
syntax on

" Color column at 81
set colorcolumn=81
au BufNewFile,BufRead *.scala set colorcolumn=130

" set color scheme to solarized
syntax on
let g:solarized_termcolors=256
set t_Co=256
set background=dark
colorscheme solarized

" to keep whitespace highlighting on recognized file types
au FileType * highlight WhitespaceEOL ctermbg=240 guibg=red

" md means markdown
au BufNewFile,BufReadPost *.md set filetype=markdown

" JSX highlighting
let g:jsx_ext_required=0

" Panes should split to the right, or to the bottom
set splitbelow
set splitright

" NERDTree Remaps
let NERDTreeMapOpenExpl='\t'

" FZF Remaps
nnoremap <silent> <c-p> :Files<CR>

" Gutentags
let g:gutentags_cache_dir="~/.tags"
