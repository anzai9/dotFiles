return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		version = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-node-modules.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{
				"nvim-tree/nvim-web-devicons",
				enabled = vim.g.have_nerd_font,
			},
		},
		config = function()
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")
			local action_layout = require("telescope.actions.layout")
			local action_state = require("telescope.actions.state")
			-- local action_utils = require('telescope.actions.utils')

			vim.keymap.set(
				"n",
				"<leader>ff",
				builtin.find_files,
				{ desc = "[F]ind [F]iles" }
			)
			vim.keymap.set(
				"n",
				"<leader>fg",
				builtin.live_grep,
				{ desc = "[F]ind [G]rep", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fb",
				builtin.buffers,
				{ desc = "[F]ind existing [B]buffers", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fh",
				builtin.help_tags,
				{ desc = "[F]ind [H]elp", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fo",
				builtin.oldfiles,
				{ desc = "[F]ind [O]ld Files", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>*",
				builtin.grep_string,
				{ desc = "[F]ind current word", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fd",
				builtin.diagnostics,
				{ desc = "[F]ind [D]iagnostics" }
			)
			vim.keymap.set(
				"n",
				"<leader>:",
				builtin.command_history,
				{ desc = "[F]ind command history", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fT",
				"<cmd>TodoTelescope<cr>",
				{ desc = "[F]ind all todo", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>ft",
				"<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
				{ desc = "[F] [T]odo, fix, fixme", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fa",
				builtin.autocommands,
				{ desc = "[F]ind [A]utocommands", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fk",
				builtin.keymaps,
				{ desc = "[F]ind [K]eymap", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>fr",
				builtin.resume,
				{ desc = "[F]ind [R]esume" }
			)
			vim.keymap.set(
				"n",
				"<leader>fs",
				builtin.builtin,
				{ desc = "[F]ind [S]elect Telescope" }
			)

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(
					require("telescope.themes").get_dropdown({
						winblend = 18,
						previewer = false,
					})
				)
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader>f/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[F]ind [/] in Open Files" })

			vim.keymap.set("n", "<leader>fn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[F]ind [N]eovim files" })

			vim.keymap.set({ "n", "x" }, "<leader>rr", function()
				require("telescope").extensions.refactoring.refactors()
			end, { desc = "[R]efactor selector" })

			vim.keymap.set("n", "<leader>fq", function()
				require("telescope").extensions.rest.select_env()
			end, { desc = "[F]ind rest.nvim [Q]uery env" })

			local custom_actions = {}

			custom_actions.project_files = function()
				local opts = {}
				local ok = pcall(builtin.git_files, opts)
				if not ok then
					builtin.find_files(opts)
				end
			end

			-- fallback to find_files while the git_files cannot find a .git directory
			vim.keymap.set("n", "<C-p>", function()
				custom_actions.project_files()
			end, { silent = true, desc = "[] Find git files" })

			-- local print_table = function(tbl)
			-- 	print('print_table: ')
			-- 	print(type(tbl))
			-- 	if type(tbl) ~= 'table' then
			-- 		print(tbl)
			-- 		return
			-- 	end
			-- 	for k, v in pairs(tbl) do
			-- 		print(k, v)
			-- 	end
			-- end

			-- open multiple files at once
			custom_actions._multiple_open = function(prompt_bufnr, open_cmd)
				-- print("prompt_bufnr: " .. prompt_bufnr)
				-- print("open_cmd: ", open_cmd)
				local picker = action_state.get_current_picker(prompt_bufnr)
				local search_res_count = picker.manager:num_results()
				if search_res_count == 0 then
					return
				end

				-- local results = {}
				-- action_utils.map_entries(prompt_bufnr, function(entry, index, row)
				--   results[row] = entry.value
				-- end)
				-- print_table(results)
				local selected_count = #picker:get_multi_selection()
				if not selected_count or selected_count <= 1 then
					actions.add_selection(prompt_bufnr)
				end
				actions.send_selected_to_qflist(prompt_bufnr)
				vim.cmd("cfdo " .. open_cmd)
			end

			custom_actions.multi_selection_open_vsplit = function(prompt_bufnr)
				custom_actions._multiple_open(prompt_bufnr, "vsplit")
			end

			custom_actions.multi_selection_open_split = function(prompt_bufnr)
				custom_actions._multiple_open(prompt_bufnr, "split")
			end

			custom_actions.multi_selection_open_tab = function(prompt_bufnr)
				custom_actions._multiple_open(prompt_bufnr, "tabedit")
			end

			custom_actions.multi_selection_open = function(prompt_bufnr)
				custom_actions._multiple_open(prompt_bufnr, "edit")
			end

			require("telescope").setup({
				defaults = {
					path_display = {
						shorten = { len = 5, exclude = { 1, -1 } },
					},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--trim",
					},
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<esc>"] = actions.close,
							["<C-w>"] = action_layout.toggle_preview,
							["<C-x>"] = false,
						},
						n = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<esc>"] = actions.close,
							["<C-w>"] = action_layout.toggle_preview,
						},
					},
				},
				pickers = {
					buffers = {
						previewer = false,
						mappings = {
							i = {
								["<C-b>"] = "delete_buffer",
							},
						},
					},
					find_files = {
						previewer = false,
						find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
						mappings = {
							i = {
								["<CR>"] = custom_actions.multi_selection_open,
								["<C-V>"] = custom_actions.multi_selection_open_vsplit,
								["<C-S>"] = custom_actions.multi_selection_open_split,
								["<C-T>"] = custom_actions.multi_selection_open_tab,
							},
						},
					},
					oldfiles = {
						previewer = false,
						mappings = {
							i = {
								["<CR>"] = custom_actions.multi_selection_open,
								["<C-V>"] = custom_actions.multi_selection_open_vsplit,
								["<C-S>"] = custom_actions.multi_selection_open_split,
								["<C-T>"] = custom_actions.multi_selection_open_tab,
							},
						},
					},
					git_files = {
						previewer = false,
						mappings = {
							i = {
								["<CR>"] = custom_actions.multi_selection_open,
								["<C-V>"] = custom_actions.multi_selection_open_vsplit,
								["<C-S>"] = custom_actions.multi_selection_open_split,
								["<C-T>"] = custom_actions.multi_selection_open_tab,
							},
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})
			pcall(require("telescope").load_extension, "node_modules")
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "refactoring")
			pcall(require("telescope").load_extension, "rest")

			return custom_actions
		end,
	},
	"nvim-tree/nvim-web-devicons",
	{ -- show key bindings hint
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup()

			-- Document existing key chains
			wk.add({
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>f", group = "[F]ind" },
				{ "<leader>w", group = "[W]rite" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>x", group = "[]Trouble" },
				{ "<leader>g", group = "[G]it" },
				{ "<leader>n", group = "[N]ew" },
				{ "[", group = "Previous" },
				{ "]", group = "Next" },
				{ "<leader>a", group = "[A]i" },
			})
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Trouble",
		opts = {
			-- width = 200,
			-- signs = {
			-- 	error = "error",
			-- 	warning = "warn",
			-- 	hint = "hint",
			-- 	information = "info",
			-- },
		},
		keys = {
			{
				"<leader>xq",
				"<cmd>Trouble qflist toggle<cr>",
				{ silent = true, desc = "Trouble qucikfix" },
			},
			{
				"<leader>xw",
				"<cmd>Trouble diagnostics toggle<cr>",
				{ silent = true, desc = "Trouble workspace diagnostics" },
			},
			{
				"<leader>xd",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				{ silent = true, desc = "Toggle Trouble document diagnostics" },
			},
			{
				"<leader>xl",
				"<cmd>Trouble loclist toggle<cr>",
				{ silent = true, desc = "Toggle Trouble loclist" },
			},
			{
				"gR",
				"<cmd>Trouble lsp_references toggle<cr>",
				{ silent = true, desc = "Toggle Trouble lsp references" },
			},
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").previous({ new = false })
					else
						vim.cmd.cprev()
					end
				end,
				{ silent = true, desc = "Previous Trouble" },
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ new = false })
					else
						vim.cmd.cnext()
					end
				end,
				{ silent = true, desc = "Next Trouble" },
			},
		},
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon.setup({})

			local function map(key, cmd, desc)
				vim.keymap.set("n", key, cmd, { desc = "Harpoon: " .. desc })
			end

			map("<leader>a", function()
				harpoon:list():add()
			end, "Add current file to Harpoon")
			map("<C-e>", function()
				require("telescope").extensions.harpoon.marks(harpoon:list())
			end, "Open harpoon window")
			map("<leader>1", function()
				harpoon:list():select(1)
			end, "Select file 1")
			map("<leader>2", function()
				harpoon:list():select(2)
			end, "Select file 2")
			map("<leader>3", function()
				harpoon:list():select(3)
			end, "Select file 3")
			map("<leader>4", function()
				harpoon:list():select(4)
			end, "Select file 4")

			-- Toggle previous & next buffers stored within Harpoon list
			map("[h", function()
				harpoon:list():prev()
			end, "Prev [H]arpoon file")
			map("]h", function()
				harpoon:list():next()
			end, "Next [H]arpoon file")

			pcall(require("telescope").load_extension, "harpoon")
		end,
	},
	"mbbill/undotree", -- undo
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = false,
				view_options = {
					show_hidden = true,
				},
			})
			vim.keymap.set(
				"n",
				"-",
				"<CMD>Oil<CR>",
				{ desc = "Open parent directory" }
			)
		end,
	},
	{
		"OlegGulevskyy/better-ts-errors.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		ft = { "typescript", "typescriptreact" },
	},
	{
		"barrett-ruth/live-server.nvim",
		build = function()
			local pkg = "live-server"
			local cmd = vim.fn.executable("pnpm") == 1 and ("pnpm add -g " .. pkg)
				or ("npm install -g " .. pkg)
			local res = os.execute(cmd)
			if res ~= 0 then
				vim.notify("Failed to install" .. pkg, vim.log.levels.ERROR)
			end
		end,
		cmd = { "LiveServerStart", "LiveServerStop" },
		config = true,
	},
}
