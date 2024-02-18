return {
  { -- copilot
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      panel = {
        enabled = false
      },
      suggestion = {
        enabled = false,
      }
    },
    dependencies = {
      'zbirenbaum/copilot-cmp',
    }
  },
  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end
  },
  { -- codeium
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
      })
      vim.g.codeium_disable_bindings = 1
    end
  },
  {
    'max397574/better-escape.nvim',
    opts = {
      mapping = { "jj" },
      timeout = 300,
      clear_empty_lines = true,
    },
  },
  {
    'numToStr/Comment.nvim',
    dependencies = {
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = {
          enable_autocmd = false,
        },
      },
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    config = function()
      local prehook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
      require("Comment").setup({
        pre_hook = prehook,
      })
    end
  },
  {
    'folke/todo-comments.nvim',
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { 'n', ']t', '<cmd>lua require("todo-comments").jump_next()<CR>', desc = "Next todo comment" },
      { 'n', '[t', '<cmd>lua require("todo-comments").jump_prev()<CR>', desc = "Previous todo comment" }
    }
  },
}
