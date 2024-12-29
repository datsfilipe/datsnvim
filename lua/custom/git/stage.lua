local M = {}

function M.stage_hunk()
  local file = vim.fn.expand '%'
  local current_line = vim.fn.line '.'

  -- Get the full diff with more context
  local diff_cmd = string.format('git diff -U3 -- %s', file)
  local diff_output = vim.fn.system(diff_cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify('failed to get git diff', vim.log.levels.ERROR)
    return
  end

  local current_hunk = nil
  local hunk_patch = {}
  local file_headers = {}
  local in_target_hunk = false

  for line in diff_output:gmatch '[^\n]+' do
    if
      line:match '^diff '
      or line:match '^index '
      or line:match '^--- '
      or line:match '^+++ '
    then
      -- Collect file header lines
      table.insert(file_headers, line)
    elseif line:match '^@@' then
      -- Match hunk header
      local _, _, old_start, old_count, new_start, new_count =
        line:find '@@ [-](%d+),?(%d*) [+](%d+),?(%d*) @@'

      old_count = old_count ~= '' and old_count or '1'
      new_count = new_count ~= '' and new_count or '1'

      if old_start and new_start then
        local hunk_start = tonumber(new_start)
        local hunk_end = hunk_start + tonumber(new_count) - 1

        if current_line >= hunk_start and current_line <= hunk_end then
          in_target_hunk = true
          current_hunk = { start = hunk_start, end_ = hunk_end }
          table.insert(hunk_patch, line)
        elseif in_target_hunk then
          break
        end
      end
    elseif in_target_hunk then
      table.insert(hunk_patch, line)
    end
  end

  if not current_hunk then
    vim.notify('no changes found at current line', vim.log.levels.WARN)
    return
  end

  -- Combine headers and hunk patch
  local patch_content = vim.list_extend(file_headers, hunk_patch)

  -- Write patch to a temporary file
  local temp_file = os.tmpname()
  local f = io.open(temp_file, 'w')

  if not f then
    vim.notify('failed to open temporary file', vim.log.levels.ERROR)
    return
  end

  f:write(table.concat(patch_content, '\n') .. '\n')
  f:close()

  -- Apply patch
  local patch_cmd = string.format('git apply --cached %s', temp_file)
  local result = vim.fn.system(patch_cmd)

  os.remove(temp_file)

  if vim.v.shell_error ~= 0 then
    vim.notify('failed to stage hunk: ' .. result, vim.log.levels.ERROR)
  else
    vim.notify('staged hunk', vim.log.levels.INFO)
  end
end

return M
