vim.api.nvim_set_hl(0, 'GitNumAdd', { link = 'DiagnosticSignInfo' })
vim.api.nvim_set_hl(0, 'GitNumChange', { link = 'DiagnosticSignWarn' })
vim.api.nvim_set_hl(0, 'GitNumDelete', { link = 'DiagnosticSignError' })

local ns = vim.api.nvim_create_namespace 'NativeGitSigns'
local timer = assert(vim.uv.new_timer())

local function update_git_signs()
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  if filepath == '' then
    return
  end

  timer:stop()
  timer:start(
    200,
    0,
    vim.schedule_wrap(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      vim.system({ 'git', 'show', 'HEAD:' .. vim.fn.fnamemodify(filepath, ':.') }, { text = true }, function(obj)
        if obj.code ~= 0 then
          return
        end

        local git_content = obj.stdout
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end

          local buf_content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n') .. '\n'
          local hunks = vim.text.diff(git_content, buf_content, { result_type = 'indices' })

          vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

          if not hunks then
            return
          end
          ---@diagnostic disable-next-line: param-type-mismatch
          for _, hunk in ipairs(hunks) do
            local type = 'GitNumChange'
            local text = '│'
            if hunk[2] == 0 then
              type, text = 'GitNumAdd', '│'
            end
            if hunk[4] == 0 then
              type, text = 'GitNumDelete', '_'
            end

            local start_line = hunk[3]
            local count = hunk[4]

            if count == 0 then
              count = 1
              if start_line == 0 then
                start_line = 1
              end
            end

            for i = 0, count - 1 do
              local line = start_line + i - 1
              if line >= 0 then
                vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
                  sign_text = text,
                  sign_hl_group = type,
                  priority = 10,
                })
              end
            end
          end
        end)
      end)
    end)
  )
end

local group = vim.api.nvim_create_augroup('NativeGitSigns', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufWritePost', 'TextChanged', 'TextChangedI' }, {
  group = group,
  callback = update_git_signs,
})
