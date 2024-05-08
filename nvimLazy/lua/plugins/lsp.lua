return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim', -- Install tools for LSP
      { 'j-hui/fidget.nvim',       opts = {} }, -- lsp progress (optional)
      { 'folke/neodev.nvim',       opts = {} }, -- config lua_ls for newvim config
      { 'b0o/SchemaStore.nvim' }, -- json schema validator
      {
        'kevinhwang91/nvim-ufo',   -- folding tool
        dependencies = {'kevinhwang91/promise-async'},
        config = function()
          vim.o.foldcolumn = '1'
          vim.o.foldlevel = 99
          vim.o.foldlevelstart = 99
          vim.o.foldenable = true
        end
      },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('chien-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          local builtin = require('telescope.builtin')
          --  To jump back, press <C-t>
          map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
          map('gr', builtin.lsp_references, '[G]oto [R]eferences')
          map('gI', builtin.lsp_implementations, '[G]oto [I]mplementations')
          map('<leader>D', builtin.lsp_type_definitions, 'Type [D]finition')
          map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Diagnostic keymaps
          map('[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic message')
          map(']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic message')
          map('<leader>e', vim.diagnostic.open_float, 'Open diagnostic [E]rror messages')
          map('<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')
        end
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        gopls = {},
        rust_analyzer = {},
        tsserver = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                disable = { 'missing-fields' },
                globals = { 'vim' },
              },
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              format = {
                enable = true,
              },
              validate = {
                enable = true,
              }
            }
          }
        },
        prismals = {
          settings = {
            prisma = {
              prismaFmtBinPath = 'prisma-fmt',
              prismaFmtArgs = { '--indent-width=4' },
              lint = {
                enable = true,
                autoFix = true,
              },
              format = {
                enable = true,
                autoFix = true,
              },
            }
          }
        }
      }

      require("fidget").setup({})
      require('mason').setup()
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'prettierd',
        "eslint_d",
        'tailwindcss',
        'goimports',
        'jq',
        'yamlls',
        "jsonlint",
      })
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = '[Z]: ' .. desc })
      end
      local ufo = require('ufo')
      map('zR', ufo.openAllFolds, 'Fold all')
      map('zM', ufo.closeAllFolds, 'Close all')
      require('ufo').setup()
    end
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    lazy = false,
    keys = {
      {
        '<leader>fm',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { "ruff", "isort", "black" },
        javascript = { "prettierd", "eslint_d" },
        typescript = { "prettierd", "eslint_d" },
        javascriptreact = { "prettierd", "eslint_d" },
        typescriptreact = { "prettierd", "eslint_d" },
        go = { 'goimports' },
        json = { 'jq' },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
      },
    },
    config = function()
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- completion = { completeopt = 'menu,menuone,noinsert' },

        -- `:help ins-completion`
        mapping = cmp.mapping.preset.insert({
          ['<S-Tab>'] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select,
          }),
          ['<Tab>'] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select,
          }),
          ['<C-k>'] = cmp.mapping.confirm({
            -- behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<C-Space>"] = cmp.mapping.complete(),
          -- scroll up and down in the completion documentation
          ['<C-d>'] = cmp.mapping.scroll_docs(5),
          ['<C-u>'] = cmp.mapping.scroll_docs(-5),
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = "path" },
          { name = "copilot" },
          { name = "codeium" },
          { name = "nvim_lsp" },
          { name = "buffer",  keyword_length = 3 },
          { name = "luasnip", keyword_length = 2 },
        },
      })
      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            }
          }
        })
      })
    end
  }
}
