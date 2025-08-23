local M = {}

M.diagnostics = {
  ERROR = '-',
  WARN = '~',
  HINT = '∴',
  INFO = '+',
}

M.symbol_kinds = {
  Array = '',
  Class = '',
  Color = '',
  Constant = '',
  Constructor = '',
  Enum = '',
  EnumMember = '',
  Event = '',
  Field = '',
  File = '',
  Folder = '',
  Function = '',
  Interface = '',
  Keyword = '',
  Method = '',
  Module = '',
  Operator = '',
  Property = '',
  Reference = '',
  Snippet = '',
  Struct = '',
  Text = '',
  TypeParameter = '',
  Unit = '',
  Value = '',
  Variable = '',
}

M.lazy_icons = {
  cmd = '(cmd)',
  config = '(cfg)',
  event = '(>>)',
  favorite = '(fav)',
  ft = '(ft)',
  init = '(init)',
  import = '(imp)',
  keys = '(key)',
  lazy = '(_)',
  loaded = '(*)',
  not_loaded = '(x)',
  plugin = '(plug)',
  runtime = '(run)',
  require = '(req)',
  source = '(src)',
  start = '(start)',
  task = '(done)',
  list = {
    '*',
    '->',
    '+',
    '-',
  },
}

return M
