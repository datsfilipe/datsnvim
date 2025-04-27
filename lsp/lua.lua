local utils = require 'utils'
if not utils.is_bin_available 'lua-language-server' then
  return
end

return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath 'config'
        and (
          vim.uv.fs_stat(path .. '/.luarc.json')
          or vim.uv.fs_stat(path .. '/.luarc.jsonc')
        )
      then
        return
      end
    end

    client.config.settings.Lua =
      vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            '${3rd}/luv/library',
          },
        },
      })

    client:notify(
      vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
      { settings = client.config.settings }
    )
  end,

  settings = {
    Lua = {
      format = { enable = false },
      hint = {
        enable = true,
        arrayIndex = 'Disable',
      },
      completion = { callSnippet = 'Replace' },
    },
  },
}
