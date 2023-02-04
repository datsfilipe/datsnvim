local download_packer = function()
  local directory = string.format('%s/site/pack/packer/start/', vim.fn.stdpath 'data')

  vim.fn.mkdir(directory, 'p')

  local out = vim.fn.system(
    string.format('git clone %s %s', 'https://github.com/wbthomason/packer.nvim', directory .. '/packer.nvim')
  )

  print(out)
  print 'Downloading packer.nvim...'
  vim.cmd [[qa]]
end

return download_packer
