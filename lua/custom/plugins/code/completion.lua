local completion_utils = require 'utils.cmp'

return {
  'echasnovski/mini.completion',
  version = '*',
  opts = {
    fallback_action = '<C-n>',
    set_vim_settings = false,
    window = {
      info = { height = 10, width = 80, border = 'none' },
      signature = { height = 10, width = 80, border = 'none' },
    },
    mappings = {
      force_twostep = '',
      force_fallback = '',
    },
    lsp_completion = {
      source_func = 'omnifunc',
      process_items = function(items, base)
        local res = vim.tbl_filter(function(item)
          local text = item.filterText
            or completion_utils.get_completion_word(item)
          return vim.startswith(text, base) and item.kind ~= 15
        end, items)

        res = vim.deepcopy(res)
        table.sort(res, function(a, b)
          return completion_utils.should_come_first(a, b, base)
        end)

        return res
      end,
    },
  },
}
