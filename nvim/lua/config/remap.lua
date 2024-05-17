vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw" })

local opts = { silent = true }

-- move beginning and end of line
vim.keymap.set("n", "H", "^", { desc = "Move to the beginning of the line" })
vim.keymap.set("n", "L", "$", { desc = "Move to the end of the line" })
-- move cursor by display lines when wrap is on
vim.keymap.set(
	"n",
	"j",
	"v:count == 0 ? 'gj' : 'j'",
	{ expr = true, silent = true }
)
vim.keymap.set(
	"n",
	"k",
	"v:count == 0 ? 'gk' : 'k'",
	{ expr = true, silent = true }
)
-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- move line up and down when in v mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
-- stay at middle line when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move [D]own half page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move [U]p half page" })
-- append next line to the end of current line without move the cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join next line to current line" })
-- yank into the system clipboard
vim.keymap.set(
	{ "n", "v" },
	"<leader>y",
	[['+y]],
	{ desc = "[Y]ank into the system clipboard" }
)
vim.keymap.set(
	"n",
	"<leader>Y",
	[['+Y]],
	{ desc = "[Y]ank into the system clipboard with line" }
)
-- Shortcut for faster save
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "[W]rite file" })
-- disable capital q to quit just in case
vim.keymap.set("n", "Q", "<nop>")
-- Close a buffer and switching to another buffer, do not close the
-- window, see https://stackoverflow.com/q/4465095/6064933
vim.keymap.set(
	"n",
	"<C-X>",
	"<cmd>bprevious <bar> bdelete #<CR>",
	{ desc = "Close buffer" }
)
-- Split
vim.keymap.set(
	"n",
	"<leader>h",
	":<C-U>split<CR>",
	{ desc = "[H]rizontal split" }
)
vim.keymap.set(
	"n",
	"<leader>v",
	":<C-U>vsplit<CR>",
	{ desc = "[V]ertical split" }
)
-- Undo Panel
vim.keymap.set(
	"n",
	"<leader>u",
	":UndotreeToggle<CR>",
	{ desc = "Toggle [U]ndo tree" }
)
-- Clear search with <esc>
vim.keymap.set(
	"n",
	"<Esc>",
	"<cmd>nohlsearch<CR>",
	{ desc = "Escape and clear hlsearch" }
)
-- New file
vim.keymap.set("n", "<leader>nf", "<cmd>new<cr>", { desc = "[N]ew [F]ile" })
--  See `:help wincmd` for a list of all window commands
vim.keymap.set(
	"n",
	"<C-h>",
	"<C-w><C-h>",
	{ desc = "Move focus to the left window" }
)
vim.keymap.set(
	"n",
	"<C-l>",
	"<C-w><C-l>",
	{ desc = "Move focus to the right window" }
)
vim.keymap.set(
	"n",
	"<C-j>",
	"<C-w><C-j>",
	{ desc = "Move focus to the lower window" }
)
vim.keymap.set(
	"n",
	"<C-k>",
	"<C-w><C-k>",
	{ desc = "Move focus to the upper window" }
)
