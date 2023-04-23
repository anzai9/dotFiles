local silent = { silent = true }

vim.keymap.set("n", "<leader>n", function() require("harpoon.mark").add_file() end)
vim.keymap.set("n", "<leader>tc", function () require("harpoon.cmd-ui").toggle_quick_menu() end, silent)
vim.keymap.set("n", "<C-e>", "<cmd>Telescope harpoon marks<cr>", silent)

vim.keymap.set("n", "<leader>j", function() require("harpoon.ui").nav_file(1) end, silent)
vim.keymap.set("n", "<leader>k", function() require("harpoon.ui").nav_file(2) end, silent)
vim.keymap.set("n", "<leader>l", function() require("harpoon.ui").nav_file(3) end, silent)
vim.keymap.set("n", "<leader>;", function() require("harpoon.ui").nav_file(4) end, silent)
