local hop = require("hop")

hop.setup({
  case_insensitive = true,
  char2_fallback_key = '<CR>',
  quit_key='<Esc>',
})

vim.keymap.set("n", "f", function()
  return hop.hint_char1()
end, { silent =true, desc = "nvim-hop char1" })
