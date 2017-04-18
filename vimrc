"""""""""""""""""
" .vimrc by dm4 "
"               "
"""""""""""""""""

" my listchars is utf-8
scriptencoding utf-8

call plug#begin()
Plug 'Lokaltog/vim-easymotion'
Plug 'scrooloose/nerdtree'
Plug 'msanders/snipmate.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'sjl/gundo.vim'
Plug 'c9s/simple-commenter.vim'
Plug 'AutoComplPop'
Plug 'hexHighlight.vim'
Plug 'dm4/vim-writer'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'mattn/emmet-vim'
Plug 'junegunn/vim-easy-align'
Plug 'altercation/vim-colors-solarized'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'kchmck/vim-coffee-script'
Plug 'Valloric/YouCompleteMe'
call plug#end()

" indent
set expandtab
set autoindent
set smartindent
set cindent
set ignorecase
set hls

" tab and space
set shiftwidth=4
set tabstop=4
set softtabstop=4

" backup info
set backup
set backupdir=$HOME/.vim/backup/
if exists("*mkdir") && !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup")
endif

" undo
set undofile
set undodir=$HOME/.vim/undo/
if exists("*mkdir") && !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo")
endif

" set line break
set nowrap
set linebreak
"set showbreak=>>\ 

" other settings
set nu
syntax on
set ruler
"set mouse=a
set bs=2
set showcmd
set foldmethod=marker

" invisible character
set nolist
set listchars=tab:▸\ ,trail:▝,eol:¬

" mininum split window size
set winminheight=0
set winminwidth=0

" auto reload vimrc
autocmd! BufWritePost *vimrc source %

" set filetype
autocmd BufReadPost,BufNewFile *.tt set filetype=html
autocmd BufReadPost,BufNewFile httpd*.conf set filetype=apache
autocmd BufReadPost,BufNewFile *.md set filetype=markdown

" set indent
autocmd BufReadPost,BufNewFile *.rb set sw=2 ts=2 softtabstop=2
autocmd BufReadPost,BufNewFile *.erb set sw=2 ts=2 softtabstop=2
"autocmd BufReadPost,BufNewFile *.html set sw=2 ts=2 softtabstop=2
autocmd FileType javascript set sw=2 ts=2 softtabstop=2
autocmd FileType json set sw=2 ts=2 softtabstop=2

" Show diff when git commit
autocmd FileType gitcommit DiffGitCached

" for vim-go
autocmd FileType go nmap <Leader>gdv <Plug>(go-doc-vertical)
autocmd FileType go nmap <Leader>gdt <Plug>(go-doc-tab)
autocmd FileType go nmap <leader>gr <Plug>(go-run)
autocmd FileType go nmap <Leader>gi <Plug>(go-implements)

" Save last postion
if has("autocmd")
   autocmd BufReadPost *
      \ if line("'\"") > 0 && line ("'\"") <= line("$") |
      \   exe "normal g'\"" |
      \ endif
endif

" key mapping
let mapleader=","
nmap ; :
vmap ; :
nmap j gj
nmap k gk
vmap j gj
vmap k gk
imap <C-D>      <DEL>
nmap <C-L>      :set nu!<CR>
nmap <C-n>      gt
nmap <C-p>      gT
imap <C-a>      <HOME>
imap <C-e>      <END>
imap <C-f>      <RIGHT>
imap <C-b>      <LEFT>
nmap <C-J>      ddp==
nmap <C-K>      ddkP==
nmap <Leader>n  <plug>NERDTreeTabsToggle<CR>
nmap <Leader>gun :GundoToggle<CR>
nmap <Leader>b  :e ++enc=big5<CR>
nmap <Leader>u  :e ++enc=utf-8<CR>
nmap <Leader>p  :set paste!<CR>
nmap <Leader>r  :set wrap!<CR>
nmap <Leader>ev :tabnew $MYVIMRC<CR>
nmap <Leader>h  :set hls!<CR>
nmap <Leader>s  :w<CR>:source %<CR>
nmap <Leader>i  :set list!<CR>

" ctrl-tab only works on gui
nmap <C-Tab>    gt

" hexHighlight plugin
nmap <Leader>l :call HexHighlight()<CR>

" Show syntax highlighting groups for word under cursor
nmap <C-C> :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Encoding
set fileencodings=utf-8,big5,euc-jp,gbk,euc-kr,utf-bom,iso8859-1

" color setting
if $TERM == "xterm-256color" || $TERM == "screen-256color"
    " set 256 colors
    set t_Co=256
elseif $TERM == "xterm"
    set t_Co=16
endif

" theme setting
set cursorline
set background=dark
silent! colorscheme solarized

" Highlight trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" set status line
set laststatus=2
set statusline=%{(&paste)?'[p]':''}
set statusline+=%m%f
set statusline+=%=
set statusline+=(%{mode()})
set statusline+=\ \ 
set statusline+=[%{&fenc}]
set statusline+=\ \ 
set statusline+=[%{&ft!=''?&ft:'none'}]
set statusline+=\ \ 
set statusline+=Col\ %c,\ Line\ %l/%L
set statusline+=\ \ 
set statusline+=%p%%\ 

" NERDTree
let g:nerdtree_tabs_open_on_gui_startup = 0

" simplecommenter
let g:oneline_comment_padding = ''

if has("gui_running")
    " set colors
    set background=light
    silent! colorscheme solarized
"    set guifont=Monaco:h17
    set guifont=Source\ Code\ Pro:h18

    " window size
    set lines=100
    set columns=90

    " hide tool bar
    set guioptions+=c
    set guioptions-=e
    set guioptions-=T
    set guioptions-=m
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L

    " disable input manager
    set imdisable
    set antialias

    if has("gui_macvim")
        " set CMD+ENTER fullscreen
        set fuopt=maxhorz,maxvert
"        set fullscreen
    endif
endif
