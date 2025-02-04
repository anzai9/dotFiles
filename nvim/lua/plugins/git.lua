-- Only load those plugins if the current buffer is a git repository
local is_inside_git_repo = function()
	local git_dir = vim.fn.finddir(".git", vim.fn.expand("%:p:h") .. ";")
	return vim.fn.isdirectory(git_dir) ~= 0
end

return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = function()
			local ng = require("neogit")
			ng.setup({
				disable_commit_confirmation = true,
				integrations = {
					diffview = true,
				},
			})
			vim.keymap.set("n", "<leader>gs", function()
				ng.open()
			end, { silent = true, desc = "neo[G]it [S]tart" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, { desc = "Gitsigns Next [C]hange" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, { desc = "Gitsigns Prev [C]hange" })

				-- Actions
				map("n", "gh", gs.stage_hunk, { desc = "[G]itsigns Stage [H]unk" })
				map("v", "gh", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Gitsigns Stage Hunk" })
				map("n", "gH", gs.reset_hunk, { desc = "[G]itsigns Reset [H]unk" })
				map("v", "gH", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Gitsigns Reset Hunk" })
				map("n", "<leader>gd", gs.diffthis, { desc = "[G]itsigns [D]iff View" })
				map("n", "<leader>gD", function()
					gs.diffthis("~1")
				end, { desc = "Gitsigns Diff View with ~" })

				-- Text object
				map(
					{ "o", "x" },
					"ih",
					":<C-U>Gitsigns select_hunk<CR>",
					{ desc = "Gitsigns select hunk in Operator and Ex mode" }
				)
			end,
		},
	},
	"sindrets/diffview.nvim",
	{
		"akinsho/git-conflict.nvim",
		lazy = not is_inside_git_repo(),
		config = function()
			require("git-conflict").setup({
				default_mappings = true, -- disable buffer local mapping created by this plugin
				default_commands = true, -- disable commands created by this plugin
				disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
				highlights = {
					incoming = "DiffAdd",
					current = "DiffText",
				},
			})
		end,
	},
}
