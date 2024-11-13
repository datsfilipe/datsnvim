local completion_utils = require 'utils.completion_utils'

return {
  'echasnovski/mini.completion',
  version = '*',
  opts = {
    fallback_action = '<C-n>',
    set_vim_settings = false,
    mappings = {
      force_twostep = '',
      force_fallback = '',
    },
    lsp_completion = {
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
