return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"python",
				"go",
				"lua",
				"c",
				"cpp",
				"vim",
				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",
				"yaml",
				"toml",
				"json",
				"rust",
				"markdown",
				"markdown_inline",
				"graphql",
				"bash",
				"regex",
				"jsdoc",
				"sql",
				"cmake",
				"http",
				"diff",
			},
			sync_install = true,

			auto_install = true,

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			indent = { enable = true, disable = {} },

			incremental_selection = {
				enabble = true,
			},

			textObjects = { enable = true, lsp_interop = { enable = true } },

			autotag = {
				enable = true,
				enable_rename = true,
				enable_close = true,
				enable_close_on_slash = true,
			},
		},
		config = function(_, opts)
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
			require("nvim-treesitter.install").prefer_git = true
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			vim.keymap.set("n", "[n", function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end, { silent = true, desc = "Goto top of treesitter co[N]text" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}
