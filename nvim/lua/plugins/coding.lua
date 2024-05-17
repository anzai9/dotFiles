return {
	{ -- copilot
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = false,
			},
		},
		dependencies = {
			"zbirenbaum/copilot-cmp",
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	-- { -- codeium
	--   "Exafunction/codeium.nvim",
	--   dependencies = {
	--     "nvim-lua/plenary.nvim",
	--     "hrsh7th/nvim-cmp",
	--   },
	--   config = function()
	--     require("codeium").setup({
	--     })
	--     vim.g.codeium_disable_bindings = 1
	--   end
	-- },
	{
		"max397574/better-escape.nvim",
		opts = {
			mapping = { "jj" },
			timeout = 300,
			clear_empty_lines = true,
		},
	},
	{
		"numToStr/Comment.nvim",
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				opts = {
					enable_autocmd = false,
				},
			},
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local prehook = require(
				"ts_context_commentstring.integrations.comment_nvim"
			).create_pre_hook()
			require("Comment").setup({
				pre_hook = prehook,
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = "VimEnter",
		keys = {
			{
				"]t",
				'<cmd>lua require("todo-comments").jump_next()<CR>',
				desc = "Next todo comment",
			},
			{
				"[t",
				'<cmd>lua require("todo-comments").jump_prev()<CR>',
				desc = "Previous todo comment",
			},
		},
		config = function()
			require("todo-comments").setup({})
		end,
	},
	{ "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl" }, -- indent
	"tpope/vim-repeat", -- replace copy actions by delete using m to replace d
	{
		"svermeulen/vim-easyclip",
		config = function()
			vim.g.EasyClipAutoFormat = 1
			vim.g.EasyClipAlwaysMoveCursorToEndOfPaste = 1
			vim.g.EasyClipPreserveCursorPositionAfterYank = 1
		end,
	},
	{
		"easymotion/vim-easymotion",
		config = function()
			vim.keymap.set("", "/", "<Plug>(easymotion-sn)", { noremap = false })
			vim.keymap.set("o", "/", "<Plug>(easymotion-tn)", { noremap = false })

			vim.g.EasyMotion_smartcase = 1
			vim.g.EasyMotion_do_mapping = 0
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			modes = {
				char = {
					jump_labels = true,
				},
			},
		},
		keys = {
			{
				".", -- Select any word
				mode = { "n", "v" },
				function()
					require("flash").jump({
						search = {
							mode = function(pattern)
								-- remove leading dot
								if pattern:sub(1, 1) == "." then
									pattern = pattern:sub(2)
								end
								-- return word pattern and proper skip pattern
								return ([[\<%s\w*\>]]):format(pattern),
									([[\<%s]]):format(pattern)
							end,
						},
						jump = { pos = "range" },
					})
				end,
				desc = "Flash select any word word",
			},
		},
	},
	"terryma/vim-multiple-cursors",
	{
		"echasnovski/mini.nvim",
		config = function()
			-- :h MiniAi-textobject-builtin
			require("mini.ai").setup({ n_lines = 500 })
			-- like vim-sandwitch
			require("mini.surround").setup()

			-- simple statsline
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
}
