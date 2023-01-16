require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "help",
    "python",
    "go",
    "lua",
    "c",
    "cpp",
    "vim",
    "javascript",
    "typescript",
    "tsx",
    "html",
    "css",
    "yaml",
    "toml",
    "json",
    "rust",
    "markdown",
    "graphql",
    "bash",
  },
  sync_install = false,

  auto_install = true,

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
