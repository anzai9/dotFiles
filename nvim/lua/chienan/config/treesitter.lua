require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "python",
    "go",
    "lua",
    "c",
    "cpp",
    "vim",
    "javascript",
    "typescript",
    "html",
    "css",
    "yaml",
    "toml",
    "json",
    "rust",
    "markdown",
    "graphql",
  },
  sync_install = false,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
    disable = {},
  },

  incremental_selection = {
    enabble = true,
  },

  textObjects = {
    enalbe = true,
  },

  autotag = {
    enable = true,
  }
}
