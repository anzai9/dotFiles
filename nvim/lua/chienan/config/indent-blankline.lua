require("indent_blankline").setup({
  -- U+2502 may also be a good choice, it will be on the middle of cursor.
  -- U+250A is also a good choice
  char = "|",
  show_end_of_line = false,
  disable_with_nolist = true,
  buftype_exclude = { "terminal", "nofile" },
  filetype_exclude = { "help", "git", "markdown", "snippets", "text", "gitconfig", "alpha" },
})

vim.cmd([[
function! Should_activate_indentblankline() abort
  if index(g:indent_blankline_filetype_exclude, &filetype) == -1
    IndentBlanklineEnable
  endif
endfunction
augroup indent_blankline
  autocmd!
  autocmd InsertEnter * call Should_activate_indentblankline()
  autocmd InsertLeave * call Should_activate_indentblankline()
augroup END
]])
