call plug#begin('~/.config/nvim/plugged')
" Language Client
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'

" File explorer with icons
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'

" Golang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Typescript Syntax Highlight
Plug 'peitalin/vim-jsx-typescript', {'for': 'ts'}

" Rust
Plug 'rust-lang/rust.vim'

" Theme
Plug 'gruvbox-community/gruvbox'

" Easy Motion
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'fannheyward/telescope-coc.nvim'

" Tab line
Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'

" Multi-cursor
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Undo handling
Plug 'mbbill/undotree'

" git
Plug 'tpope/vim-fugitive'

" commenter
Plug 'preservim/nerdcommenter'

" replace copy behavior on all delete action
Plug 'tpope/vim-repeat'
Plug 'svermeulen/vim-easyclip'

" Help escape insert mode quickly
Plug 'jdhao/better-escape.vim'
call plug#end()
" General Settings
syntax enable
filetype plugin indent on
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
set bs=2
set fileencoding=utf-8
set fileencodings=utf-8
set ffs=unix,dos,mac
set textwidth=80
set noerrorbells
set wrap
set colorcolumn=80
" Highlight the row and column
set cursorline
" Fix backspace indent
set backspace=indent,eol,start
" A buffer becomes hidden when it is abandoned
set hidden
" Highlight search results
set nohlsearch
" Makes search act like search in modern browsers
set incsearch
" For regular expressions turn magic on
set magic
" Show matching brackets when text indicator is over them
set showmatch
set smartindent " smart about indent
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile
set shiftwidth=4
set tabstop=4
set showcmd " retain command
set expandtab " always uses spaces insaed of tab characters
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
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" term GUI colors
if (has("termguicolors"))
    set termguicolors
endif
colorscheme gruvbox

" Mappings
" better-escape
let g:better_escape_shortcut = 'jj'
let g:better_escape_interval = 100
" easyclip
let g:EasyClipAutoFormat = 1
let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
let g:EasyClipPreserveCursorPositionAfterYank = 1
let g:EasyClipShareYanks = 1
let g:EasyClipShareYanksDirectory = "/Users/jianan_wang/.config/nvim"
" easymotion
let g:EasyMotion_do_mapping = 1 " Disable default mappings
let g:EasyMotion_leader_key = "<Leader>"
let g:EasyMotion_smartcase = 1  " Turn on case-insensitive feature
nmap s <Plug>(easymotion-overwin-f2)
" You can use other keymappings like <C-l> instead of <CR> if you want to
" use these mappings as default search and sometimes want to move cursor with
" EasyMotion.
function! s:incsearch_config(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {
  \     "\<CR>": '<Over>(easymotion)'
  \   },
  \   'is_expr': 0
  \ }), get(a:, 1, {}))
endfunction
noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))
" incsearch.vim x fuzzy x vim-easymotion
function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzyword#converter()],
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \ }), get(a:, 1, {}))
endfunction
noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())
" With a map leader it is possible to do extra key combinations
let mapleader = " "
" Fast saving
nmap <leader>w :w!<cr>
" Move among buffers with mapleader"
map <leader>. :bnext<cr>
map <leader>, :bprev<cr>
" Mundo toggle
nnoremap <leader>u :MundoToggle<CR>
" NERDTree toggle
nnoremap <leader>t :NERDTreeToggle<CR>
" Git
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>ga :Gwrite<CR>
nnoremap <leader>gb :Bblame<CR>
nnoremap <leader>gll :Gpull<CR>
nnoremap <leader>gd :Gvdiff<CR>
" Split
nnoremap <leader>h :<C-u>split<CR>
nnoremap <leader>v :<C-u>vsplit<CR>
" Undo Panel
nnoremap <F5> :UndotreeToggle<CR>
" turn terminal to normal mode with escape
tnoremap <ESC> <C-\><C-n>
" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" open termianl on ctrl `
function! OpenTerminal()
    split term://zsh
    set nonumber
    resize 10
endfunction
nnoremap <leader>` :call OpenTerminal()<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" auto reload vimrc when editin it
autocmd! BufWritePost .vimrc source ~/.vimrc | echo "source .vimrc"

" Abbreviations
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" Rust.vim Settings
let g:rustfmt_autosave=1
" To avoid the conflict between coc and ale
let g:ale_disable_lsp=1

"" airline status bar setting
let g:airline_filetype_overrides = {
        \ 'coc-explorer': [ 'CoC Explorer', '' ],
        \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', 'NERD'), ''],
      \ }
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" coc config
let g:coc_global_extensions = [
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-emmet'
  \ ]

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
       \ pumvisible() ? "\<C-n>" :
       \ <SID>check_back_space() ? "\<TAB>" :
       \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
 
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
 
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>fm  <Plug>(coc-format-selected)
nmap <leader>fm  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
 
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>al  :<C-u>CocList diagnostics<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>oo  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>sb  :<C-u>CocList -I symbols<cr>
