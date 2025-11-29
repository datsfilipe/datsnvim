local utils = require 'user.utils'

local M = {}

local function markdown_preview()
  if not utils.is_bin_available 'gh' then
    print 'gh is not available'
    return
  end

  local extensions = vim.fn.system('gh extension list'):gsub('\n', '')
  if not extensions:find 'gh markdown%-preview' then
    vim.cmd '!gh extension install gh-markdown-preview'
    return
  end

  local current_filetype = vim.bo.filetype
  if current_filetype ~= 'markdown' then
    vim.notify('not a markdown file', vim.log.levels.WARN)
    return
  end

  local file_path = vim.fn.expand '%:p'
  vim.fn.jobstart({ 'gh', 'markdown-preview', file_path }, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify('markdown preview failed', vim.log.levels.ERROR)
      else
        vim.notify('markdown preview opened', vim.log.levels.INFO)
      end
    end,
  })
end

function M.setup()
  vim.api.nvim_create_user_command('MarkdownPreview', markdown_preview, {})
end

return M
