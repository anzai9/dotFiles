vim.opt.termguicolors = true
return {
	{
		"norcalli/nvim-colorizer.lua",
		opts = { "css", "javascript", "typescript", "html", "!vim" },
	},
	{ -- Colorscheme section
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme catppuccin-mocha")
		end,
		opts = {
			{
				integrations = {
					diffview = true,
					fidget = true,
					indent_blankline = {
						enabled = true,
						scope_color = "lavendar",
						colored_indent_levels = false,
					},
					mason = true,
					lsp_trouble = true,
					which_key = true,
				},
			},
		},
	},
	{ "RRethy/vim-illuminate", event = { "BufReadPost", "BufNewFile" } },
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
		event = "VeryLazy",
		keys = {
			{ "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		config = function()
			local bfl = require("bufferline")
			bfl.setup({
				options = {
					numbers = "both",
					themable = true,
					show_buffer_close_icons = false,
					show_close_icon = false,
					color_icons = true,
					show_tab_indicators = true,
					indicator = { style = "icon" },
					tab_size = 18,
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level, diagnostics_dict)
						local s = " "
						for e, n in pairs(diagnostics_dict) do
							local sym = e == "error" and " "
								or (e == "warning" and " " or "")
							s = s .. n .. " " .. sym
						end
						return s
					end,
					sort_by = "insert_at_end",
					highlights = function()
						local h = require("catppuccin.groups.integrations.bufferline").get()
						return h
					end,
				},
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {
			check_ts = true,
		},
	},
	{ "windwp/nvim-ts-autotag" },
}
