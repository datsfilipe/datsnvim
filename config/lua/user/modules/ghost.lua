local M = {}

M.setup = function()
  local MODEL, API_URL, DEBOUNCE_MS =
    'qwen2.5-coder:1.5b', 'http://127.0.0.1:11434/api/generate', 500
  local insert, concat = table.insert, table.concat
  local job, timer, suggestion = nil, nil, ''
  local ns_id = vim.api.nvim_create_namespace 'ai_ghost_text'

  local function clear()
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    suggestion = ''
  end

  local function get_context()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor[1] - 1, cursor[2]
    local total_lines = vim.api.nvim_buf_line_count(0)
    local prefix_lines =
      vim.api.nvim_buf_get_lines(0, math.max(0, row - 60), row + 1, false)
    if #prefix_lines > 0 then
      prefix_lines[#prefix_lines] = prefix_lines[#prefix_lines]:sub(1, col)
    end
    local suffix_lines =
      vim.api.nvim_buf_get_lines(0, row, math.min(total_lines, row + 60), false)
    if #suffix_lines > 0 then
      suffix_lines[1] = suffix_lines[1]:sub(col + 1)
    end
    return concat(prefix_lines, '\n'), concat(suffix_lines, '\n')
  end

  local function render_ghost(text, target_row, target_col)
    if vim.api.nvim_get_mode().mode ~= 'i' then
      return
    end
    local clean = text:gsub('```', ''):gsub('<|.-|>', '')
    local first_line = clean:match '[^\n]+'
    if not first_line or first_line == '' then
      return
    end
    suggestion = first_line
    local cur = vim.api.nvim_win_get_cursor(0)
    if cur[1] - 1 ~= target_row or cur[2] ~= target_col then
      return
    end
    vim.api.nvim_buf_set_extmark(
      0,
      ns_id,
      target_row,
      target_col,
      {
        virt_text = { { first_line, 'Comment' } },
        virt_text_pos = 'overlay',
        hl_mode = 'combine',
      }
    )
  end

  local function fetch_completion()
    local prefix, suffix = get_context()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor[1] - 1, cursor[2]
    local prompt = '<|fim_prefix|>'
      .. prefix
      .. '<|fim_suffix|>'
      .. suffix
      .. '<|fim_middle|>'
    local payload = vim.json.encode {
      model = MODEL,
      prompt = prompt,
      raw = true,
      stream = false,
      options = {
        num_predict = 50,
        temperature = 0.1,
        stop = { '<|file_separator|>', '\n' },
      },
    }
    if job then
      vim.fn.jobstop(job)
    end
    local output = {}
    job = vim.fn.jobstart(
      { 'curl', '-s', '-X', 'POST', API_URL, '-d', payload },
      {
        on_stdout = function(_, data)
          for _, chunk in ipairs(data) do
            insert(output, chunk)
          end
        end,
        on_exit = function(_, code)
          if code ~= 0 then
            return
          end
          local ok, decoded = pcall(vim.json.decode, concat(output, ''))
          if ok and decoded.response then
            vim.schedule(function()
              render_ghost(decoded.response, row, col)
            end)
          end
        end,
      }
    )
  end

  vim.api.nvim_create_autocmd('TextChangedI', {
    callback = function()
      if timer then
        timer:stop()
      end
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
      suggestion = ''
      timer = vim.uv.new_timer()
      ---@diagnostic disable-next-line: need-check-nil
      timer:start(DEBOUNCE_MS, 0, vim.schedule_wrap(fetch_completion))
    end,
  })

  vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufLeave' }, {
    callback = function()
      clear()
      if job then
        vim.fn.jobstop(job)
      end
      if timer then
        timer:stop()
      end
    end,
  })

  vim.keymap.set('i', '<C-g>', function()
    if suggestion == '' then
      return
    end
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    vim.api.nvim_set_current_line(
      line:sub(1, col) .. suggestion .. line:sub(col + 1)
    )
    vim.api.nvim_win_set_cursor(0, { row, col + #suggestion })
    clear()
  end, { silent = true })
end

return M
