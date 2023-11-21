require('trouble').setup {
    icons = false,
    width = 200,
    signs = {
        error = 'error',
        warning = 'warn',
        hint = 'hint',
        information = 'info',
    }
}

vim.keymap.set('n', '<leader>xq', '<cmd>TroubleToggle quickfix<cr>',
    { silent = true }
)
vim.keymap.set('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>',
    { silent = true }
)
vim.keymap.set('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>',
    { silent = true }
)
vim.keymap.set('n', '<leader>xl', '<cmd>TroubleToggle loclist<cr>',
    { silent = true }
)
vim.keymap.set('n', '[q', function()
    if require('trouble').is_open() then
        require('trouble').previous({ skip_groups = true, jump = true })
    else
        vim.cmd.cprev()
    end
end, { silent = true })
vim.keymap.set('n', ']q', function()
    if require('trouble').is_open() then
        require('trouble').next({ skip_groups = true, jump = true })
    else
        vim.cmd.cnext()
    end
end, { silent = true })
