local nnoremap = require("chienan.utils").nnoremap

local silent = { silent = true }

nnoremap("<leader>;", function() require("harpoon.mark").add_file() end)
nnoremap("<leader>tc", function () require("harpoon.cmd-ui").toggle_quick_menu() end, silent)
nnoremap("<C-e>", "<cmd>Telescope harpoon marks<cr>", silent)

nnoremap("<leader>j", function() require("harpoon.ui").nav_file(1) end, silent)
nnoremap("<leader>k", function() require("harpoon.ui").nav_file(2) end, silent)
nnoremap("<leader>l", function() require("harpoon.ui").nav_file(3) end, silent)
nnoremap("<leader>m", function() require("harpoon.ui").nav_file(vim.v.count1) end, silent)
