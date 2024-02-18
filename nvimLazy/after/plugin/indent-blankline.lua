-- local highlight = {
--   "CursorColumn",
--   "Whitespace",
-- }
-- vim.opt.list = true
-- vim.opt.listchars:append 'eol:↴'
require('ibl').setup(
--   {
--   indent = { highlight = highlight, char = "-" },
--   whitespace = {
--     highlight = highlight,
--     remove_blankline_trail = false,
--   },
-- }
)

-- local function augroup(name)
--   return vim.api.nvim_create_augroup('chienan_' .. name, { clear = true })
-- end
--
-- vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
--   group = augroup('indent_blacnkline_disable'),
--   command = 'IBLDisable',
-- })
--
-- vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
--   group = augroup('indent_blacnkline_enable'),
--   command = 'IBLEnable',
-- })
