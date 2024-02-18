vim.opt.termguicolors = true
return {
  {
    'norcalli/nvim-colorizer.lua',
    opts = {
      'css',
      'javascript',
      'typescript',
      'html',
      '!vim',
    }
  },
  { 'windwp/nvim-autopairs' },
  { 'windwp/nvim-ts-autotag' },
  { -- Colorscheme section
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      vim.cmd('colorscheme rose-pine')
    end
  },
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
  },
  {
    "akinsho/bufferline.nvim",
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = "VeryLazy",
    keys = {
      { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        numbers = "none",
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        show_tab_indicators = true,
        indcator = {
          style = "underline",
        },
        tab_size = 24,
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
        offsets = { {
          text = "File Explorer",
          highlight = "Directory",
          text_align = "left"
        } },
      },
    }
  },
}
