local ok, ls = pcall(require, 'luasnip')
if not ok then
  return
end

local types = require 'luasnip.util.types'

ls.config.set_config {
  history = false,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { ' « ', 'NonTest' } },
      },
    },
  },
}
