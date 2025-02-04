return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim", -- Install tools for LSP
			{ "j-hui/fidget.nvim", opts = {} }, -- lsp progress (optional)
			{ "folke/neodev.nvim", opts = {} }, -- config lua_ls for newvim config
			{ "b0o/SchemaStore.nvim" }, -- json schema validator
			{
				"kevinhwang91/nvim-ufo", -- folding tool
				dependencies = { "kevinhwang91/promise-async" },
				config = function()
					vim.o.foldcolumn = "1"
					vim.o.foldlevel = 99
					vim.o.foldlevelstart = 99
					vim.o.foldenable = true
				end,
			},
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup(
					"chien-lsp-attach",
					{ clear = true }
				),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set(
							"n",
							keys,
							func,
							{ buffer = event.buf, desc = "LSP: " .. desc }
						)
					end
					local builtin = require("telescope.builtin")
					--  To jump back, press <C-t>
					map("gd", builtin.lsp_definitions, "[G]oto [D]definition")
					map("gr", builtin.lsp_references, "[G]oto [R]eferences")
					map("gI", builtin.lsp_implementations, "[G]oto [I]mplementations")
					map("<leader>D", builtin.lsp_type_definitions, "Type [D]finition")
					map(
						"<leader>ds",
						builtin.lsp_document_symbols,
						"[D]ocument [S]symbols"
					)
					map(
						"<leader>ws",
						builtin.lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]symbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Diagnostic keymaps
					map(
						"[d",
						vim.diagnostic.goto_prev,
						"Go to previous [D]iagnostic message"
					)
					map("]d", vim.diagnostic.goto_next, "Go to next [D]iagnostic message")
					map(
						"<leader>e",
						vim.diagnostic.open_float,
						"Open diagnostic [E]rror messages"
					)
					map(
						"<leader>q",
						vim.diagnostic.setloclist,
						"Open diagnostic [Q]uickfix list"
					)
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend(
				"force",
				capabilities,
				require("cmp_nvim_lsp").default_capabilities()
			)
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							imports = {
								granularity = {
									group = "module",
								},
								prefix = "self",
							},
							cargo = {
								buildScripts = {
									enable = true,
								},
							},
							procMacro = {
								enable = true,
							},
						},
					},
				},
				ts_ls = {
					settings = {
						typescript = {
							-- Inlay Hints preferences
							inlayHints = {
								-- You can set this to 'all' or 'literals' to enable more hints
								includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = false,
								includeInlayVariableTypeHints = false,
								includeInlayVariableTypeHintsWhenTypeMatchesName = false,
								includeInlayPropertyDeclarationTypeHints = false,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
							-- Code Lens preferences
							implementationsCodeLens = {
								enabled = true,
							},
							referencesCodeLens = {
								enabled = true,
								showOnAllFunctions = true,
							},
							format = {
								indentSize = vim.o.shiftwidth,
								convertTabsToSpaces = vim.o.expandtab,
								tabSize = vim.o.tabstop,
							},
						},
						javascript = {
							-- Inlay Hints preferences
							inlayHints = {
								-- You can set this to 'all' or 'literals' to enable more hints
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
								includeInlayVariableTypeHints = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
							-- Code Lens preferences
							implementationsCodeLens = {
								enabled = true,
							},
							referencesCodeLens = {
								enabled = true,
								showOnAllFunctions = true,
							},
							format = {
								indentSize = vim.o.shiftwidth,
								convertTabsToSpaces = vim.o.expandtab,
								tabSize = vim.o.tabstop,
							},
						},
						completions = {
							completeFunctionCalls = true,
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = {
								disable = { "missing-fields" },
								globals = { "vim" },
							},
						},
					},
				},
				jsonls = {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							format = {
								enable = true,
							},
							validate = {
								enable = true,
							},
						},
					},
				},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								-- You must disable built-in schemaStore support if you want to use
								-- this plugin and its advanced options like `ignore`.
								enable = false,
								-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},
				prismals = {
					settings = {
						prisma = {
							prismaFmtBinPath = "prisma-fmt",
							prismaFmtArgs = { "--indent-width=4" },
							lint = {
								enable = true,
								autoFix = true,
							},
							format = {
								enable = true,
								autoFix = true,
							},
						},
					},
				},
			}

			require("fidget").setup({})
			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"prettierd",
				-- "prettier",
				-- "eslint_d",
				"eslint",
				"rustywind",
				"jq",
				"yq",
			})
			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend(
							"force",
							{},
							capabilities,
							server.capabilities or {}
						)
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			local map = function(keys, func, desc)
				vim.keymap.set("n", keys, func, { desc = "[Z]: " .. desc })
			end
			local ufo = require("ufo")
			map("zR", ufo.openAllFolds, "Fold all")
			map("zM", ufo.closeAllFolds, "Close all")
			require("ufo").setup()
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		config = function()
			local conform = require("conform")
			local slow_format_filetypes = {}

			---@param bufnr integer
			---@param ... string
			---@return string
			local function first(bufnr, ...)
				for i = 1, select("#", ...) do
					local formatter = select(i, ...)
					if conform.get_formatter_info(formatter, bufnr).available then
						return formatter
					end
				end
				return select(1, ...)
			end

			local function react_format(bufnr)
				if
					require("conform").get_formatter_info("rustywind", bufnr).available
				then
					return {
						"rustywind",
						first(bufnr, "prettier", "prettierd"),
						first(bufnr, "eslint", "eslint_d"),
					}
				else
					return {
						first(bufnr, "prettier", "prettierd"),
						first(bufnr, "eslint", "eslint_d"),
					}
				end
			end

			local function js_format(bufnr)
				return {
					first(bufnr, "prettierd", "prettier"),
					first(bufnr, "eslint", "eslint_d"),
				}
			end

			conform.setup({
				notify_on_error = false,
				format_on_save = function(bufnr)
					if slow_format_filetypes[vim.bo[bufnr].filetype] then
						return
					end

					if vim.b["disable_autoformat"] or vim.g.disable_autoformat then
						return
					end

					local disable_filetypes = { c = true, cpp = true }
					if vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
						return
					end

					local function on_format(err)
						if err and err:match("timeout$") then
							slow_format_filetypes[vim.bo[bufnr].filetype] = true
						end
					end

					return {
						timeout_ms = 800,
						lsp_fallback = "fallback",
					},
						on_format
				end,
				format_after_save = function(bufnr)
					if not slow_format_filetypes[vim.bo[bufnr].filetype] then
						return
					end
					return { lsp_fallback = true }
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					python = function(bufnr)
						if
							require("conform").get_formatter_info("ruff_format", bufnr).available
						then
							return { "ruff_format" }
						else
							return { "isort", "black" }
						end
					end,
					javascript = js_format,
					typescript = js_format,
					javascriptreact = react_format,
					typescriptreact = react_format,
					go = { "goimports", "golines", "gofumpt" },
					json = { "jq" },
					yaml = { "yq" },
					markdown = function(bufnr)
						return { first(bufnr, "prettierd", "prettier") }
					end,
					terraform = { "terraform_fmt" },
					["*"] = { "codespell" },
				},
				default_format_opts = {
					lsp_format = "fallback",
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>fm", function()
				require("conform").format({
					lsp_fallback = true,
					async = true,
				}, function(err)
					if not err then
						local mode = vim.api.nvim_get_mode().mode
						if vim.startswith(string.lower(mode), "v") then
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
								"n",
								true
							)
						end
					end
				end)
			end, { desc = "[F]ormat buffer and range (in view mode)" })

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					vim.b["disable_autoformat"] = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})

			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b["disable_autoformat"] = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		lazy = false,
		priority = 100,
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "text_symbol", -- 'text', 'text_symbol', 'symbol_text', 'symbol'
						maxwidth = function()
							return math.floor(0.45 * vim.o.columns)
						end,
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
						show_labelDetails = true, -- show labelDetails in menu. Disabled by default
						-- The function below will be called before any actual modifications from lspkind
						-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
						before = function(entry, vim_item)
							return vim_item
						end,
					}),
				},
				-- `:help ins-completion`
				mapping = cmp.mapping.preset.insert({
					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item({
						behavior = cmp.SelectBehavior.Select,
					}),
					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item({
						behavior = cmp.SelectBehavior.Select,
					}),
					-- Accept ([y]es) the completion.
					["<C-y>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
					["<C-Space>"] = cmp.mapping.complete(),
					-- scroll up and down in the completion documentation
					["<C-d>"] = cmp.mapping.scroll_docs(5),
					["<C-u>"] = cmp.mapping.scroll_docs(-5),
					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "copilot" },
					-- { name = "codeium" },
					{ name = "path" },
					{ name = "nvim_lsp" },
					{ name = "buffer", keyword_length = 3 },
					{ name = "luasnip", keyword_length = 2 },
				},
			})

			cmp.setup.filetype({ "sql" }, {
				sources = {
					{ name = "vim-dadbod-completion" },
					{ name = "buffer" },
				},
			})

			-- `:` cmdline setup.
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.code_actions.gitsigns,
					null_ls.builtins.code_actions.proselint, -- English style linter
					null_ls.builtins.code_actions.refactoring,
					-- require("none-ls.code_actions.eslint_d"),
					require("none-ls.code_actions.eslint"),

					null_ls.builtins.diagnostics.trail_space,
					null_ls.builtins.diagnostics.proselint,
					null_ls.builtins.diagnostics.golangci_lint, -- Go linter
					null_ls.builtins.diagnostics.staticcheck, -- Go static analysis tool
					null_ls.builtins.diagnostics.hadolint, -- Dockerfile linter
					null_ls.builtins.diagnostics.mypy, -- python type checker
					require("none-ls.diagnostics.ruff"), -- python linter
					null_ls.builtins.diagnostics.selene, -- lua linter
					null_ls.builtins.diagnostics.stylelint, -- css lint
					-- require("none-ls.diagnostics.eslint_d"),
					require("none-ls.diagnostics.eslint"),
					-- terraform linters
					null_ls.builtins.diagnostics.terraform_validate,
					null_ls.builtins.diagnostics.tfsec,
					null_ls.builtins.diagnostics.trivy,
				},
			})
		end,
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("refactoring").setup({})
			vim.keymap.set("x", "<leader>re", function()
				require("refactoring").refactor("Extract Function")
			end, { desc = "[R]efactor [E]xtract function" })
			vim.keymap.set("x", "<leader>rf", function()
				require("refactoring").refactor("Extract Function To File")
			end, { desc = "[R]efactor extract function to [F]ile" })
			vim.keymap.set("x", "<leader>rv", function()
				require("refactoring").refactor("Extract Variable")
			end, { desc = "[R]efactor extract [V]ariable" })
			vim.keymap.set("n", "<leader>rI", function()
				require("refactoring").refactor("Inline Function")
			end, { desc = "[R]efactor [I]line function" })
			vim.keymap.set({ "n", "x" }, "<leader>ri", function()
				require("refactoring").refactor("Inline Variable")
			end, { desc = "[R]efactor [i]line variable" })

			vim.keymap.set("n", "<leader>rb", function()
				require("refactoring").refactor("Extract Block")
			end, { desc = "[R]efactor [B]lock" })
			vim.keymap.set("n", "<leader>rbf", function()
				require("refactoring").refactor("Extract Block To File")
			end, { desc = "[R]efactor [B]lock to [F]ile" })
		end,
	},
}
