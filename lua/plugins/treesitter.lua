return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  config = function()
    local ts = require "nvim-treesitter.configs"

    ts.setup {
      highlight = {
        enable = true,
        disable = {},
      },
      indent = {
        enable = true,
      },
      ensure_installed = {
        "tsx",
        "typescript",
        "toml",
        "json",
        "css",
        "html",
        "lua",
        "yaml",
        "markdown",
        "markdown_inline",
        "bash",
      },
      autotag = {
        enable = true,
      },
    }

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

    vim.filetype.add {
      extension = {
        mdx = "mdx",
      },
    }

    vim.treesitter.language.register("markdown", "mdx")
  end,
  build = function()
    local ts_update = require("nvim-treesitter.install").update { with_sync = true }
    ts_update()
  end,
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {},
    },
    "nvim-treesitter/playground",
  },
}

