vim.opt.termguicolors = true
require("bufferline").setup {
  options = {
    numbers = "buffer_id",
    close_command = "bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    max_name_length = 24,
    max_prefix_length = 15,
    tab_size = 24,
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,
    diagnostics = "coc",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = " "
        for e, n in pairs(diagnostics_dict) do
          local sym = e == "error" and " "
            or (e == "warning" and " " or "" )
          s = s .. n .. " " .. sym
        end
      return s
    end,

    offsets = {{
      filetype = "NvimTree",
      text = "File Explorer",
      highlight = "Directory",
      text_align = "left"
    }},
  }
}
