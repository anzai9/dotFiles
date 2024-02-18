return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
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
        "markdown_inline",
        "graphql",
        "bash",
        "regex",
        "jsdoc",
        "sql",
        "cmake",
        "http",
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
        enable = true,
      },

      autotag = {
        enable = true,
      }
    },
  },
}
