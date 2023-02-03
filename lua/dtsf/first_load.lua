local question_file = '/tmp/.nvim_packer_question'

local download_packer = function()
  if os.rename(question_file, question_file) == nil then
    os.execute('touch ' .. question_file)
  elseif os.rename(question_file, question_file) ~= nil then
    return
  end

  if vim.fn.input('Download Packer? (y for yes)') ~= 'y' then
    return
  end

  local directory = string.format('%s/site/pack/packer/start/', vim.fn.stdpath 'data')

  vim.fn.mkdir(directory, 'p')

  local out = vim.fn.system(
    string.format('git clone %s %s', 'https://github.com/wbthomason/packer.nvim', directory .. '/packer.nvim')
  )

  print(out)
  print 'Downloading packer.nvim...'
  print '( You\'ll need to restart now )'
  vim.cmd [[qa]]
end

local has_packer

return function()
  if not pcall(require, 'packer') then
    download_packer()

    return true
  end

  return false
end
