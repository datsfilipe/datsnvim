local question_file = '/tmp/.nvim_packer_question'

local prompt_question = function()
  if os.rename(question_file, question_file) == nil then
    os.execute('touch ' .. question_file)
  else
    return false
  end

  if vim.fn.input('Download Packer? (y for yes)') ~= 'y' then
    return false
  end

  return true
end

return prompt_question
