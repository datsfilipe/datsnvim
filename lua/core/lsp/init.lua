local lspconfig = vim.F.npcall(require, "lspconfig")
if not lspconfig then
  return
end

local map = require("core.utils").map
local autocmd = require("core.utils").autocmd
local autocmd_clear = vim.api.nvim_clear_autocmds

local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
local augroup_codelens = vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })

local filetype_attach = setmetatable({
  ocaml = function()
    -- Display type information
    autocmd_clear { group = augroup_codelens, buffer = 0 }
    autocmd {
      { "BufEnter", "BufWritePost", "CursorHold" },
      augroup_codelens,
      require("core.lsp.codelens").refresh_virtlines,
      0,
    }

    map {
      "n",
      "<space>tt",
      require("core.lsp.codelens").toggle_virtlines,
      { silent = true, desc = "[T]oggle [T]ypes", buffer = 0 },
    }
  end,
}, {
  __index = function()
    return function() end
  end,
})

local custom_attach = function(client, bufnr)
  if client.name == "copilot" then
    return
  end

  local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  local lsp_maps = require "keymap.plugins.lspzero"
  lsp_maps(client, bufnr)

  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  if client.server_capabilities.documentHighlightProvider then
    autocmd_clear { group = augroup_highlight, buffer = bufnr }
    autocmd { "CursorHold", augroup_highlight, vim.lsp.buf.document_highlight, bufnr }
    autocmd { "CursorMoved", augroup_highlight, vim.lsp.buf.clear_references, bufnr }
  end

  if filetype == "typescript" or filetype == "lua" then
    client.server_capabilities.semanticTokensProvider = nil
  end

  filetype_attach[filetype]()
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
updated_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

-- Completion configuration
vim.tbl_deep_extend("force", updated_capabilities, require("cmp_nvim_lsp").default_capabilities())
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }

local rust_analyzer, rust_analyzer_cmd = nil, { "rustup", "run", "nightly", "rust-analyzer" }
rust_analyzer = {
  cmd = rust_analyzer_cmd,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}

local servers = {
  bashls = true,
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    },
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
    },
  },

  gdscript = true,
  -- graphql = true,
  html = true,
  pyright = true,
  vimls = true,
  yamlls = true,
  ocamllsp = {
    settings = {
      codelens = { enable = true },
    },

    get_language_id = function(_, ftype)
      return ftype
    end,
  },

  clojure_lsp = true,

  jsonls = {
    settings = {
      json = {
        validate = { enable = true },
      },
    },
  },

  cmake = (1 == vim.fn.executable "cmake-language-server"),

  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
    },
    init_options = {
      clangdFileStatus = true,
    },
    filetypes = {
      "c",
    },
  },

  gopls = {
    settings = {
      gopls = {
        codelenses = { test = true },
        hints = nil,
      },
    },

    flags = {
      debounce_text_changes = 200,
    },
  },

  rust_analyzer = rust_analyzer,

  -- nix language server
  nil_ls = true,

  -- eslint = true,
  tsserver = {
    init_options = {
      hostInfo = "neovim",
      preferences = {
        importModuleSpecifierPreference = "non-relative",
      },
      documentFormatting = false,
    },
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },

    on_attach = function(client)
      custom_attach(client)

      client.resolved_capabilities.document_formatting = false
    end,
  },
}

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "jsonls" },
}

local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
  }, config)

  lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end

local ts_fmts = { "eslint_d" }

require("conform.formatters.stylua").require_cwd = true
local conform = require "conform"
conform.setup {
  formatters_by_ft = {
    lua = { "stylua" },
    typescript = ts_fmts,
    typescriptreact = ts_fmts,
    javascript = ts_fmts,
    javascriptreact = ts_fmts,
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    conform.format { bufnr = args.buf, lsp_fallback = true }
  end,
})

-- nvim-lint for diagnostics
local lint = require "lint"
lint.linters_by_ft = {
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
  callback = function()
    lint.try_lint()
  end,
})

vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
    spacing = 0,
  },
}

-- icons
vim.cmd [[
  sign define DiagnosticSignError text=● texthl=DiagnosticSignError linehl= numhl=
  sign define DiagnosticSignWarn text=● texthl=DiagnosticSignWarn linehl= numhl=
  sign define DiagnosticSignInfo text=● texthl=DiagnosticSignInfo linehl= numhl=
  sign define DiagnosticSignHint text=● texthl=DiagnosticSignHint linehl= numhl=
]]

return {
  on_init = custom_init,
  on_attach = custom_attach,
  capabilities = updated_capabilities,
}
