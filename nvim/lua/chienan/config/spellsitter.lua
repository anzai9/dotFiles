-- https://github.com/lewis6991/spellsitter.nvim
local ok, spellsitter = pcall(require, "spellsitter")
if not ok then
  vim.notify("spellsitter not found")
  return
end

spellsitter.setup({
  enable = true,
})
