vim.opt.list = true
vim.opt.listchars:append 'eol:↴'
require('ibl').setup({
  -- U+2502 may also be a good choice, it will be on the middle of cursor.
  -- U+250A is also a good choice
  indent = { char = "|" },
  -- disable_with_nolist = true,
  -- exclude = {
  --   filetypes = {
  --     'help', 'git', 'markdown', 'snippets', 'text', 'gitconfig', 'alpha', 'lspinfo', 'packer',
  --     'checkhealth', 'Trouble'
  --   }
  -- }
})

local function augroup(name)
  return vim.api.nvim_create_augroup('chienan_' .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  group = augroup('indent_blacnkline_disable'),
  command = 'IBLDisable',
})

vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  group = augroup('indent_blacnkline_enable'),
  command = 'IBLEnable',
})
