vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
require("nvim-treesitter.configs").setup {
  ensure_installed = {"python", "go", "lua", "cpp", "vim", "javascript", "typescript", "html", "css", "yaml", "toml", "rust", "json"},
  sync_install = false,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enabble = true,
  },

  textObjects = {
    enalbe = true,
  }
}
