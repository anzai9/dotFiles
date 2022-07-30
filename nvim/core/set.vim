" General Settings
syntax enable
filetype plugin indent on
" fix the statusline
set laststatus=3
" set space for indentline
set tabstop=2
set expandtab
set autoindent " Note: 'smartindent' is deprecated by 'cindnet' and 'indentexpr'
" set the space of indent
set shiftwidth=2
set exrc
set clipboard+=unnamedplus
set history=50
set scrolloff=8
set number
set rnu
set autoread
set foldcolumn=1
set wildmenu " vim c-mode auto completion suggestion
let $LANG='en'
set langmenu=en
set fileencoding=utf-8
set fileencodings=utf-8
set ffs=unix,dos,mac
set textwidth=80
set noerrorbells
set wrap
set colorcolumn=80
set ignorecase
set smartcase
" Highlight the row and column
set cursorline
" A buffer becomes hidden when it is abandoned
set hidden
" highlight search results
set hlsearch
" Makes search act like search in modern browsers
set incsearch
" For regular expressions turn magic on
set magic
" Show matching brackets when text indicator is over them
set showmatch
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set noswapfile
" retain command
set showcmd
" open new split panels to right and below
set splitright
set splitbelow
" save undo trees in files
set undofile
set undodir=~/.config/nvim/undodir
" number of undo saved
set undolevels=10000
" Below content are from the coc.vim readme https://github.com/neoclide/coc.nvim/tree/9a59eedbfdadb73b05579f12571ad92d4626898e#example-vim-configuration
" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" set the backspace can delete characters in insert mode
set backspace=indent,eol,start
colorscheme tokyonight
