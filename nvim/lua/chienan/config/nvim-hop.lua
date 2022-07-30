local hop = require("hop")
local nnoremap = require("chienan.utils").nnoremap

hop.setup({
  case_insensitive = true,
  char2_fallback_key = '<CR>',
  quit_key='<Esc>',
})

nnoremap("s", function()
  return hop.hint_char2()
end, { silent =true, desc = "nvim-hop char2" })
