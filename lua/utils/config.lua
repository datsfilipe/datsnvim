local nix = require 'external.nix'

local M = {}

M.colorscheme = nix.colorscheme or 'min-theme'
M.indent_color = '#343434'

M.sign_icons = {
  Error = 'E',
  Warn = 'W',
  Info = 'I',
  Hint = 'H',
}

M.cmp_priorities = {
  'Method',
  'Function',
  'Constructor',
  'Field',
  'Variable',
  'Class',
  'Interface',
  'Module',
  'Property',
  'Unit',
  'Value',
  'Enum',
  'Keyword',
  'File',
  'Snippet',
  'Color',
  'Reference',
  'Folder',
  'EnumMember',
  'Constant',
  'Struct',
  'Event',
  'Operator',
  'TypeParameter',
  'Text',
}

return M
