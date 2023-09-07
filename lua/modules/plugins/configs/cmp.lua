local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

cmp.setup {
  preselect = "item",
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  mapping = require "keymap.plugins.cmp",
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    { name = "buffer", keyword_length = 3 },
    { name = "luasnip", keyword_length = 2 },
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
}