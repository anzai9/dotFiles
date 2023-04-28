vim.g.mapleader = " "
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

local opts = { silent = true }

-- move cursor by display lines when wrap is on
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- move line up and down when in v mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
-- stay at middle line when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
-- append next lien to the end of current line without move the cursor
vim.keymap.set("n", "J", "mzJ`z", opts)
-- yank into the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- Shortcut for faster save and quit
vim.keymap.set("n", "<leader>w", ":<C-U>update<CR>", opts)
-- disable captial q to quit just in case
vim.keymap.set("n", "Q", "<nop>")
-- Close a buffer and switching to another buffer, do not close the
-- window, see https://stackoverflow.com/q/4465095/6064933
vim.keymap.set("n", "<C-X>", ":<C-U>bprevious <bar> bdelete #<CR>", opts)
-- Move among buffers with mapleader"
vim.keymap.set("", "]b", ":bnext<CR>", opts)
vim.keymap.set("", "[b", ":bprev<CR>", opts)
-- Split
vim.keymap.set("n", "<leader>h", ":<C-U>split<CR>", opts)
vim.keymap.set("n", "<leader>v", ":<C-U>vsplit<CR>", opts)
-- Undo Panel
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", opts)
-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
-- New file
vim.keymap.set("n", "<leader>nf", "<cmd>enew<cr>", { desc = "New File" })
