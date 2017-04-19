"""""""""""""""""
" .vimrc by dm4 "
"               "
"""""""""""""""""

" my listchars is utf-8
scriptencoding utf-8

call plug#begin()
Plug 'AutoComplPop'
Plug 'hexHighlight.vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'altercation/vim-colors-solarized'
Plug 'c9s/simple-commenter.vim'
Plug 'davidhalter/jedi-vim'
Plug 'dm4/vim-writer'
Plug 'easymotion/vim-easymotion'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/vim-easy-align'
Plug 'kchmck/vim-coffee-script'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdtree'
Plug 'sjl/gundo.vim'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'
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
autocmd BufReadPost,BufNewFile *.md        set filetype=markdown
autocmd BufReadPost,BufNewFile *.tt        set filetype=html
autocmd BufReadPost,BufNewFile httpd*.conf set filetype=apache

" tabs & spaces
autocmd FileType eruby      set sw=2 ts=2 softtabstop=2
autocmd FileType html       set sw=2 ts=2 softtabstop=2
autocmd FileType javascript set sw=2 ts=2 softtabstop=2
autocmd FileType json       set sw=2 ts=2 softtabstop=2
autocmd FileType ruby       set sw=2 ts=2 softtabstop=2
autocmd FileType yaml       set sw=2 ts=2 softtabstop=2

" Show diff when git commit
autocmd FileType gitcommit DiffGitCached

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
imap <C-A>   <HOME>
imap <C-B>   <LEFT>
imap <C-D>   <DEL>
imap <C-E>   <END>
imap <C-F>   <RIGHT>
nmap <C-J>   ddp==
nmap <C-K>   ddkP==
nmap <C-L>   :set nu!<CR>
nmap <C-N>   gt
nmap <C-P>   gT
nmap <C-Tab> gt
nmap <Leader>b   :e ++enc=big5<CR>
nmap <Leader>ev  :tabnew $MYVIMRC<CR>
map  <Leader>em  <Plug>(easymotion-prefix)
vmap <Leader>ga  <Plug>(EasyAlign)
nmap <Leader>gun :GundoToggle<CR>
nmap <Leader>h   :set hls!<CR>
nmap <Leader>i   :set list!<CR>
nmap <Leader>l   :call HexHighlight()<CR>
nmap <Leader>n   <plug>NERDTreeTabsToggle<CR>
nmap <Leader>p   :set paste!<CR>
nmap <Leader>r   :set wrap!<CR>
nmap <Leader>u   :e ++enc=utf-8<CR>
nmap <Leader>v   "+p
vmap <Leader>c   "+y
nmap <Leader>gdv <Plug>(go-doc-vertical)
nmap <Leader>gdt <Plug>(go-doc-tab)
nmap <leader>gr  <Plug>(go-run)
nmap <Leader>gi  <Plug>(go-implements)
map  <Leader>sc  <Plug>(do-comment)
map  <Leader>su  <Plug>(un-comment)
map  <Leader><Leader> <Plug>(one-line-comment)

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
let g:oneline_comment_padding  = ''
let g:scomment_default_mapping = 0

" vim-json
let g:vim_json_syntax_conceal = 0

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
