vim.opt.termguicolors = true
require("bufferline").setup {
    options = {
        numbers = "none",
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        show_tab_indicators = true,
        indcator = {style = "underline"},
        tab_size = 24,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
                local sym = e == "error" and " " or
                                (e == "warning" and " " or "")
                s = s .. n .. " " .. sym
            end
            return s
        end,
        sort_by = "insert_at_end",
        offsets = {
            {
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
            }
        }
    }
}
