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
					diagnostics_indicator = function(_count, _level, diagnostics_dict)
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
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			local res_cd = os.execute("cd app")
			if res_cd ~= 0 then
				vim.notify("Failed to build markdown-preview.nvim", "error")
			end

			local package_manager = vim.fn.execute("yarn") == 1 and "yarn" or "npm"
			local res_install = os.execute(package_manager .. " install")
			if res_install ~= 0 then
				vim.notify(
					"Failed to install dependencies for markdown-preview.nvim",
					"error"
				)
			end
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
}
