vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    local ok, supermaven = pcall(require, 'supermaven')
    if not ok then
      return
    end

    supermaven.setup {
      keymaps = {
        accept_suggestion = '<C-g>',
      },
    }
  end,
})
