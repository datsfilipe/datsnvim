return {
  event = 'InsertEnter',
  setup = function()
    local MODEL = 'qwen2.5-coder:1.5b'
    local API_URL = 'http://127.0.0.1:11434/api/generate'
    local DEBOUNCE_MS = 500

    local job = nil
    local timer = nil
    local suggestion = ''
    local ns_id = vim.api.nvim_create_namespace 'ai_ghost_text'
    local output_buffer = {}

    local function get_context()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      row = row - 1
      local total_lines = vim.api.nvim_buf_line_count(0)
      local start_row = math.max(0, row - 60)
      local end_row = math.min(total_lines, row + 60)

      local prefix_lines =
        vim.api.nvim_buf_get_lines(0, start_row, row + 1, false)
      if #prefix_lines > 0 then
        prefix_lines[#prefix_lines] =
          string.sub(prefix_lines[#prefix_lines], 1, col)
      end

      local suffix_lines = vim.api.nvim_buf_get_lines(0, row, end_row, false)
      if #suffix_lines > 0 then
        suffix_lines[1] = string.sub(suffix_lines[1], col + 1)
      end

      return table.concat(prefix_lines, '\n'), table.concat(suffix_lines, '\n')
    end

    local function render_ghost(text)
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
      suggestion = ''

      if not text or text == '' then
        return
      end

      local clean = text:gsub('```', ''):gsub('<\\|file_sep\\|>', '')
      local first_line = vim.split(clean, '\n')[1]

      if not first_line or first_line == '' then
        return
      end

      suggestion = first_line
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local line_len = #vim.api.nvim_get_current_line()

      if col > line_len then
        return
      end

      vim.api.nvim_buf_set_extmark(0, ns_id, row - 1, col, {
        virt_text = { { first_line, 'Comment' } },
        virt_text_pos = 'overlay',
        hl_mode = 'combine',
      })
    end

    local function fetch_completion()
      local prefix, suffix = get_context()
      local prompt = '<|fim_prefix|>'
        .. prefix
        .. '<|fim_suffix|>'
        .. suffix
        .. '<|fim_middle|>'

      local payload = vim.fn.json_encode {
        model = MODEL,
        prompt = prompt,
        raw = true,
        stream = false,
        options = {
          num_predict = 50,
          temperature = 0.1,
          top_p = 0.9,
          stop = { '<|file_separator|>', '\n' },
        },
      }

      if job then
        vim.fn.jobstop(job)
      end
      output_buffer = {}

      job = vim.fn.jobstart(
        { 'curl', '-s', '-X', 'POST', API_URL, '-d', '@-' },
        {
          on_stdout = function(_, data, _)
            for _, chunk in ipairs(data) do
              table.insert(output_buffer, chunk)
            end
          end,
          on_exit = function(_, code, _)
            if code ~= 0 then
              return
            end
            local raw = table.concat(output_buffer, '')
            if raw == '' then
              return
            end

            local success, decoded = pcall(vim.json.decode, raw)
            if success and decoded.response then
              vim.schedule(function()
                render_ghost(decoded.response)
              end)
            end
          end,
          stdin = 'pipe',
        }
      )

      vim.fn.chansend(job, payload)
      vim.fn.chanclose(job, 'stdin')
    end

    vim.api.nvim_create_autocmd('TextChangedI', {
      callback = function()
        vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
        suggestion = ''
        if timer then
          vim.loop.timer_stop(timer)
        end
        timer = vim.loop.new_timer()
        ---@diagnostic disable-next-line: need-check-nil
        timer:start(DEBOUNCE_MS, 0, vim.schedule_wrap(fetch_completion))
      end,
    })

    vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufLeave' }, {
      callback = function()
        vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
        if job then
          vim.fn.jobstop(job)
        end
      end,
    })

    vim.keymap.set('i', '<C-g>', function()
      if suggestion == '' then
        return
      end
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local line = vim.api.nvim_get_current_line()
      local new_line = string.sub(line, 1, col)
        .. suggestion
        .. string.sub(line, col + 1)
      vim.api.nvim_set_current_line(new_line)
      vim.api.nvim_win_set_cursor(0, { row, col + #suggestion })
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
      suggestion = ''
    end, { silent = true })
  end,
}
