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

" With a map leader it is possible to do extra key combinations
let mapleader = " "
" Shortcut for faster save and quit
nnoremap <silent> <leader>w :<C-U>update<CR>
" Saves the file if modified and quit
nnoremap <silent> <leader>q :<C-U>x<CR>
" Quit all opened buffers
nnoremap <silent> <leader>Q :<C-U>qa!<CR>
" Close a buffer and switching to another buffer, do not close the
" window, see https://stackoverflow.com/q/4465095/6064933
nnoremap <silent> <leader>x :<C-U>bprevious <bar> bdelete #<CR>
" Move among buffers with mapleader"
map <leader>. :bnext<cr>
map <leader>, :bprev<cr>
" Split
noremap <leader>h :<C-u>split<CR>
nnoremap <leader>v :<C-u>vsplit<CR>
" Undo Panel
nnoremap <F5> :UndotreeToggle<CR>
" turn terminal to normal mode with escape
tnoremap <ESC> <C-\><C-n>
" open termianl on space `
function  s:open_terminal()
 split term://zsh
 set nonumber
 resize 10
endfunction
nnoremap <leader>` :call s:open_terminal()<CR>

nnoremap <leader>zr :normal zR<CR>
nnoremap <leader>zc :normal zc<CR>
