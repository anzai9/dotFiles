return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"python",
				"go",
				"gomod",
				"gosum",
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
				"xml",
				"terraform",
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
				"gitignore",
				"gitcommit",
				"git_config",
			},
			sync_install = true,

			auto_install = true,

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			indent = { enable = true, disable = {} },

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gsi",
					node_incremental = "gsn",
					scope_incremental = "gss",
					node_decremental = "gsd",
				},
			},

			textobjects = {
				enable = true,
				lookahead = true,
				include_surrounding_whitespace = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					-- You can optionally set descriptions to the mappings (used in the desc parameter of
					-- nvim_buf_set_keymap) which plugins like which-key display
					["ic"] = {
						query = "@class.inner",
						desc = "Select inner part of a class region",
					},
					-- You can also use captures from other query groups like `locals.scm`
					["as"] = {
						query = "@local.scope",
						query_group = "locals",
						desc = "Select language scope",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				lsp_interop = {
					enable = true,
					border = "none",
					peek_definition_code = {
						["<leader>df"] = "@function.outer",
						["<leader>dF"] = "@class.outer",
					},
				},
			},

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
			local ts_repeat_move =
				require("nvim-treesitter.textobjects.repeatable_move")

			vim.keymap.set(
				{ "n", "x", "o" },
				";",
				ts_repeat_move.repeat_last_move,
				{ desc = "Repeat last treesitter move" }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				",",
				ts_repeat_move.repeat_last_move_opposite,
				{ desc = "Repeat last treesitter move opposite" }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"f",
				ts_repeat_move.builtin_f_expr,
				{ expr = true }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"F",
				ts_repeat_move.builtin_F_expr,
				{ expr = true }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"t",
				ts_repeat_move.builtin_t_expr,
				{ expr = true }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				"T",
				ts_repeat_move.builtin_T_expr,
				{ expr = true }
			)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 5,
				min_window_height = 10,
			})
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
