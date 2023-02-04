local download_packer = require('dtsf.packer.download').download_packer
local prompt_question = require('dtsf.packer.prompt_question').prompt_question
local has_packer = pcall(require, 'packer')

local auto_install_packer = function()
  if prompt_question() == true then
    download_packer()
  else
    return false
  end
end

return function()
  if not has_packer then
    auto_install_packer()

    -- checking again because auto_install could have installed it
    if not has_packer then
      vim.api.nvim_set_keymap("n", "<leader>p", "<cmd>lua require'dtsf.packer.download'.download_packer()<CR>", {noremap = true, silent = true})
    end

    return true
  end

  return false
end
