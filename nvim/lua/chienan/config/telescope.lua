local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    path_display = {
      shorten = { len = 3, exclude = { 1, -1 }}
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
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<esc>"] = actions.close,
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
    buffers = {
      mappings = {
        i = {
          ["dd"] = "delete_buffer",
        }
      }
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = ture,
      override_file_sorter = ture,
      case_mode = "smart_case",
    }
  },
}

require("telescope").load_extension("node_modules")
