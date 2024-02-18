--vim.opt.spell = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.magic = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
-- Give more space for displaying messages.
vim.opt.showcmd = true
vim.opt.wildmenu = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.laststatus = 3

vim.opt.clipboard:append { "unnamedplus" }

vim.opt.hidden = true

vim.opt.completeopt = { "menuone", "noselect", "noselect" }

vim.opt.conceallevel = 2;
