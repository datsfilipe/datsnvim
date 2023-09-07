local ok, lsp = pcall(require, "lsp-zero")
if not ok then
  return
end

lsp.preset "recommended"

lsp.ensure_installed {
  "rust_analyzer",
  "tsserver",
  "tailwindcss",
  "lua_ls",
}

-- fix undefined global 'vim'
lsp.nvim_workspace()

lsp.set_sign_icons {
  error = "",
  warn = "",
  hint = "",
  info = "",
}

local maps = require "keymap.plugins.lspzero"

lsp.on_attach(maps(_, bufnr))

-- require('lspconfig').unocss.setup {
--   cmd = { 'unocss-language-server', '--stdio' },
--   filetypes = { 'html', 'javascriptreact', 'rescript', 'typescriptreact', 'vue', 'svelte' },
--   root_dir = require('lspconfig').util.root_pattern('package.json', 'tsconfig.json', '.git'),
-- }

lsp.format_on_save {
  servers = {
    ["rust_analyzer"] = { "rust" },
  },
}

lsp.setup()

vim.diagnostic.config {
  virtual_text = true,
}