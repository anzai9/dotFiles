-- only run in http filetype
-- override the general keympa for refactoring
vim.keymap.set(
	"n",
	"<leader>rr",
	"<CMD>Rest run<CR>",
	{ silent = true, desc = "[R]est Run [R]equest under the cursor" }
)

vim.keymap.set(
	"n",
	"<leader>rl",
	"<CMD>Rest run last<CR>",
	{ silent = true, desc = "[R] est Run [L]ast request" }
)

vim.keymap.set("n", "<leader>re", function()
	require("telescope").extensions.rest.select_env()
end, { desc = "[R]est [E]nvironment select" })
