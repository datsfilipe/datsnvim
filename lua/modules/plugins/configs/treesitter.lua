local ok, ts = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

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