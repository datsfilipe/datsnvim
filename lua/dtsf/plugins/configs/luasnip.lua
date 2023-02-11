local ok, ls = pcall(require, 'luasnip')
if not ok then
  return
end

local types = require 'luasnip.util.types'

ls.config.set_config {
  -- this tells LuaSnip to remember to keep around the last snippet
  -- you can jump back into it even if you move outside of the selection
  history = false,

  -- this one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = 'TextChanged,TextChangedI',

  -- autosnippets:
  enable_autosnippets = true,

  -- crazy highlights!!
  -- #vid3
  -- ext_opts = nil,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { ' « ', 'NonTest' } },
      },
    },
  },
}
