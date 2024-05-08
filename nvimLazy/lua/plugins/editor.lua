return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    version = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-node-modules.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      {
        'nvim-tree/nvim-web-devicons',
        enabled = vim.g.have_nerd_font
      },
    },
    config = function()
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')
      local action_layout = require('telescope.actions.layout')
      local action_state = require("telescope.actions.state")

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind [G]rep', silent = true })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind existing [B]uffers', silent = true })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp', silent = true })
      vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = '[F]ind [O]ld Files', silent = true })
      vim.keymap.set('n', '<leader>*', builtin.grep_string, { desc = '[F]ind current word', silent = true })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
      vim.keymap.set('n', '<leader>:', builtin.command_history, { desc = '[F]ind command history', silent = true })
      vim.keymap.set('n', '<leader>fT', '<cmd>TodoTelescope<cr>', { desc = '[F]ind all todo', silent = true })
      vim.keymap.set('n', '<leader>ft', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>',
        { desc = '[F] [T]odo, fix, fixme', silent = true })
      vim.keymap.set('n', '<leader>fa', builtin.autocommands, { desc = '[F]ind [A]utocommands', silent = true })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymap', silent = true })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
      vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 18,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[F]ind [/] in Open Files' })

      vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[F]ind [N]eovim files' })

      local custom_actions = {}

      custom_actions.project_files = function()
        local opts = {}
        local ok = pcall(builtin.git_files, opts)
        if not ok then
          builtin.find_files(opts)
        end
      end

      -- fallback to find_files while the git_files cannot find a .git directory
      vim.keymap.set('n', '<C-p>', function()
        custom_actions.project_files()
      end, { silent = true, desc = "[] Find git files" })

      -- open multiple files at once
      custom_actions._multiple_open = function(prompt_bufnr, open_cmd)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local search_res_count = picker.manager:num_results()
        if search_res_count == 0 then
          return
        end
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

      require('telescope').setup {
        defaults = {
          path_display = {
            shorten = { len = 5, exclude = { 1, -1 } }
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
              ["<CR>"] = custom_actions.multi_selection_open,
              ["<C-V>"] = custom_actions.multi_selection_open_vsplit,
              ["<C-S>"] = custom_actions.multi_selection_open_split,
              ["<C-T>"] = custom_actions.multi_selection_open_tab,
            },
          }
        },
        pickers = {
          buffers = {
            previewer = false,
            mappings = {
              i = {
                ["<C-b>"] = "delete_buffer",
              }
            }
          },
          find_files = {
            previewer = false,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
          },
          oldfiles = {
            previewer = false,
          },
          git_files = {
            previewer = false,
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      pcall(require("telescope").load_extension, "node_modules")
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      return custom_actions
    end,
  },
  'nvim-tree/nvim-web-devicons',
  { -- show key bindings hint
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]rite', _ = 'which_key_ignore' },
        ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
        ['<leader>x'] = { name = '[]Trouble', _ = 'which_key_ignore' },
        ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
        ['<leader>n'] = { name = '[N]ew', _ = 'which_key_ignore' },
        ['['] = { name = 'Previous', _ = 'which_key_ignore' },
        [']'] = { name = 'Next', _ = 'which_key_ignore' },
      }
    end
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      icons = false,
      width = 200,
      signs = {
        error = 'error',
        warning = 'warn',
        hint = 'hint',
        information = 'info',
      }
    },
    config = function()
      vim.keymap.set('n', '<leader>xq', '<cmd>TroubleToggle quickfix<cr>',
        { silent = true, desc = "Trouble qucikfix" }
      )
      vim.keymap.set('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>',
        { silent = true, desc = "Trouble workspace diagnostics" }
      )
      vim.keymap.set('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>',
        { silent = true, desc = "Toggle Trouble document diagnostics" }
      )
      vim.keymap.set('n', '<leader>xl', '<cmd>TroubleToggle loclist<cr>',
        { silent = true, desc = "Toggle Trouble loclist" }
      )
      vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end,
        { silent = true, desc = "Toggle Trouble lsp references" })
      vim.keymap.set('n', '[q', function()
        if require('trouble').is_open() then
          require('trouble').previous({ skip_groups = true, jump = true })
        else
          vim.cmd.cprev()
        end
      end, { silent = true, desc = "Previous Trouble" })
      vim.keymap.set('n', ']q', function()
        if require('trouble').is_open() then
          require('trouble').next({ skip_groups = true, jump = true })
        else
          vim.cmd.cnext()
        end
      end, { silent = true, desc = "Next Trouble" })
    end
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      local ng = require("neogit")
      ng.setup({
        disable_commit_confirmation = true,
        integrations = {
          diffview = true,
        }
      })
      vim.keymap.set("n", "<leader>gs", function()
        ng.open()
      end, { silent = true, desc = "neo[G]it [S]tart" })
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gs.nav_hunk('next')
          end
        end, { desc = 'Gitsigns Next [C]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gs.nav_hunk('prev')
          end
        end, { desc = 'Gitsigns Prev [C]hange' })

        -- Actions
        map('n', 'gh', gs.stage_hunk, { desc = 'Gitsigns Stage Hunk' })
        map('v', 'gh', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          { desc = 'Gitsigns Stage Hunk' })
        map('n', 'gH', gs.reset_hunk, { desc = 'Gitsigns Reset Hunk' })
        map('v', 'gH', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          { desc = 'Gitsigns Reset Hunk' })
        map('n', '<leader>gd', gs.diffthis, { desc = 'Gitsigns Diff View' })
        map('n', '<leader>gD', function() gs.diffthis('~1') end, { desc = 'Gitsigns Diff View with ~' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>',
          { desc = 'Gitsigns select hunk in Operator and Ex mode' })
      end
    }
  },
  'sindrets/diffview.nvim',
  {
    'akinsho/git-conflict.nvim',
    config = function()
      require('git-conflict').setup({
        default_mappings = true,     -- disable buffer local mapping created by this plugin
        default_commands = true,     -- disable commands created by this plugin
        disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
        highlights = {
          -- They must have background color, otherwise the default color will be ,d
          incoming = 'DiffText',
          current = 'DiffAdd',
        }
      })
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')
      harpoon.setup({})

      local function map(key, cmd, desc)
        vim.keymap.set('n', key, cmd, { desc = 'Harpoon: ' .. desc })
      end

      map('<leader>a', function() harpoon:list():add() end, 'Add current file to Harpoon')
      map('<C-e>', function()
        require("telescope").extensions.harpoon.marks(harpoon:list())
      end, 'Open harpoon window')
      map('<leader>1', function() harpoon:list():select(1) end, 'Select file 1')
      map('<leader>2', function() harpoon:list():select(2) end, 'Select file 2')
      map('<leader>3', function() harpoon:list():select(3) end, 'Select file 3')
      map('<leader>4', function() harpoon:list():select(4) end, 'Select file 4')

      -- Toggle previous & next buffers stored within Harpoon list
      map('[h', function() harpoon:list():prev() end, 'Prev [H]arpoon file')
      map(']h', function() harpoon:list():next() end, 'Next [H]arpoon file')

      pcall(require("telescope").load_extension, "harpoon")
    end
  },
  'mbbill/undotree', -- undo
}
