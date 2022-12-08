local ok, ts = pcall(require, 'nvim-treesitter.configs')
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
    disable = {},
  },
  ensure_installed = {
    'tsx',
    'toml',
    'fish',
    'json',
    'css',
    'html',
    'lua',
    'yaml',
    'javascript',
    'prisma',
    'rust',
  },
  autotag = {
    enable = true,
  },
}

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.tsx.filetype_to_parsername = { 'javascript', 'typescript.tsx' }