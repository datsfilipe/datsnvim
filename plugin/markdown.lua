local function markdown_preview()
  if not require('utils').is_bin_available 'gh' then
    print 'gh is not available'
    return
  end

  local extensions = vim.fn.system('gh extension list'):gsub('\n', '')
  if not extensions:find 'gh markdown%-preview' then
    print 'markdown preview extension not found'
    return
  end

  local current_filetype = vim.bo.filetype
  if current_filetype ~= 'markdown' then
    print 'not a markdown file'
    return
  end

  vim.fn.system('gh markdown-preview ' .. vim.fn.expand '%:p' .. ' &')
end

vim.api.nvim_create_user_command('MarkdownPreview', markdown_preview, {})
