local M = {}

M.diagnostics = {
  ERROR = '-',
  WARN = '~',
  HINT = '∴',
  INFO = '+',
}

M.symbol_kinds = {
  Array = '|[]<T>|',
  Class = '|  ⊂  |',
  Color = '|  #  |',
  Constant = '|  π  |',
  Constructor = '|λ (⊂)|',
  Enum = '|  ∈  |',
  EnumMember = '| n:∈ |',
  Event = '| > > |',
  Field = '|f: {}|',
  File = '|  *  |',
  Folder = '|  /  |',
  Function = '|  λ  |',
  Interface = '|  I  |',
  Keyword = '|  4  |',
  Method = '| λ:⊂ |',
  Module = '| : : |',
  Operator = '|  *  |',
  Property = '|p: {}|',
  Reference = '|  &  |',
  Snippet = '| < > |',
  Struct = '| { } |',
  Text = '| txt |',
  TypeParameter = '|  T  |',
  Unit = '|  ∆  |',
  Value = '|  e  |',
  Variable = '|  ⍺  |',
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
