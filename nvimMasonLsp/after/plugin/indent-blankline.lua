vim.opt.list = true
vim.opt.listchars:append 'eol:↴'
require('indent_blankline').setup({
    -- U+2502 may also be a good choice, it will be on the middle of cursor.
    -- U+250A is also a good choice
    char = "|",
    show_current_context = true,
    show_current_context_start = true,
    show_end_of_line = true,
    disable_with_nolist = true,
    filetype_exclude = { 'help', 'git', 'markdown', 'snippets', 'text', 'gitconfig', 'alpha', 'lspinfo', 'packer',
        'checkhealth', 'Trouble' },
})

local function augroup(name)
    return vim.api.nvim_create_augroup('chienan_' .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
    group = augroup('indent_blacnkline_disable'),
    command = 'IndentBlanklineDisable',
})

vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
    group = augroup('indent_blacnkline_enalbe'),
    command = 'IndentBlanklineEnable',
})
