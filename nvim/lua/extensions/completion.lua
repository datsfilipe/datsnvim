local M = {}

local docs_debounce_ms = 200
local docs_timer = vim.loop.new_timer()

local function is_list(t)
  if type(t) ~= 'table' then
    return false
  end
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then
      return false
    end
  end
  return true
end

local function collect_display_parts(dp)
  if not dp then
    return nil
  end
  local out = {}
  if type(dp) == 'string' then
    table.insert(out, dp)
  elseif type(dp) == 'table' then
    if is_list(dp) then
      for _, v in ipairs(dp) do
        if type(v) == 'string' then
          table.insert(out, v)
        elseif type(v) == 'table' then
          if v.text then
            table.insert(out, v.text)
          end
          if v.displayParts then
            for _, p in ipairs(v.displayParts) do
              if p.text then
                table.insert(out, p.text)
              end
            end
          end
        end
      end
    else
      if dp.text then
        table.insert(out, dp.text)
      end
      if dp.value then
        table.insert(out, dp.value)
      end
      if dp.displayParts then
        for _, p in ipairs(dp.displayParts) do
          if p.text then
            table.insert(out, p.text)
          end
        end
      end
    end
  end
  if #out == 0 then
    return nil
  end
  return table.concat(out, '\n')
end

local function get_docs_from_item(result)
  if not result then
    return nil
  end
  local docs = result.documentation
  if type(docs) == 'string' then
    return docs
  end
  if type(docs) == 'table' then
    if docs.value and type(docs.value) == 'string' then
      return docs.value
    end
    local dp = collect_display_parts(docs)
    if dp then
      return dp
    end
  end
  if
    result.detail
    and type(result.detail) == 'string'
    and result.detail ~= ''
  then
    return result.detail
  end
  if result.displayText and type(result.displayText) == 'string' then
    return result.displayText
  end
  return nil
end

local function get_hover_docs(hover)
  if not hover then
    return nil
  end
  local c = hover.contents
  if not c then
    return nil
  end
  if type(c) == 'string' then
    return c
  end
  if type(c) == 'table' then
    if c.value and type(c.value) == 'string' then
      return c.value
    end
    local dp = collect_display_parts(c)
    if dp then
      return dp
    end
    if is_list(c) then
      local parts = {}
      for _, v in ipairs(c) do
        local piece = collect_display_parts(v)
        if piece then
          table.insert(parts, piece)
        end
      end
      if #parts > 0 then
        return table.concat(parts, '\n')
      end
    end
  end
  return nil
end

local function show_docs_popup(doc)
  if vim.fn.pumvisible() == 0 then
    return
  end
  local info = vim.fn.complete_info { 'selected' }
  if vim.tbl_isempty(info) or info.selected == -1 then
    return
  end
  local win_data = vim.api.nvim__complete_set(info.selected, { info = doc })
  if win_data and vim.api.nvim_win_is_valid(win_data.winid) then
    vim.api.nvim_win_set_config(win_data.winid, { border = 'none' })
    pcall(
      vim.api.nvim_buf_set_keymap,
      win_data.bufnr,
      'n',
      'q',
      '<Cmd>close<CR>',
      { noremap = true, silent = true }
    )
    vim.bo[win_data.bufnr].filetype = 'markdown'
    vim.wo[win_data.winid].conceallevel = 3
    vim.wo[win_data.winid].concealcursor = 'n'
  end
end

local function setup_auto_completion(client, bufnr)
  local completion_aug =
    vim.api.nvim_create_augroup('AutoCompletion' .. bufnr, { clear = true })
  local completion_timer = vim.loop.new_timer()
  local function trigger_completion()
    if vim.fn.pumvisible() == 1 then
      return
    end
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true),
      'n',
      false
    )
  end
  vim.api.nvim_create_autocmd({ 'TextChangedI' }, {
    group = completion_aug,
    buffer = bufnr,
    callback = function()
      completion_timer:stop()
      if vim.fn.pumvisible() == 1 then
        return
      end
      completion_timer:start(
        150,
        0,
        vim.schedule_wrap(function()
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local line_to_cursor = line:sub(1, col)
          if
            client.server_capabilities.completionProvider
            and client.server_capabilities.completionProvider.triggerCharacters
          then
            for _, char in
              ipairs(
                client.server_capabilities.completionProvider.triggerCharacters
              )
            do
              if line_to_cursor:sub(-1) == char then
                trigger_completion()
                return
              end
            end
          end
          if line_to_cursor:match '%w$' then
            trigger_completion()
          end
        end)
      )
    end,
  })
end

local function make_key(item)
  return (item.label or '')
    .. '\x1f'
    .. (item.detail or '')
    .. '\x1f'
    .. (item.insertText or item.textEdit and item.textEdit.newText or '')
    .. '\x1f'
    .. tostring(item.data or '')
end

local function definition_to_hover(client, bufnr, locs)
  if not locs then
    return nil
  end
  local loc = nil
  if is_list(locs) and #locs > 0 then
    loc = locs[1]
  else
    loc = locs
  end
  if not loc then
    return nil
  end
  local target_uri = loc.uri or loc.targetUri
  local range = loc.range or loc.targetSelectionRange or loc.targetRange
  if not target_uri or not range then
    return nil
  end
  local params = {
    textDocument = { uri = target_uri },
    position = range.start or range,
  }
  local got = nil
  client.request('textDocument/hover', params, function(_, hover)
    got = get_hover_docs(hover)
    if got then
      show_docs_popup(got)
    end
  end, bufnr)
  return got
end

M.setup = function()
  local augroup =
    vim.api.nvim_create_augroup('DatsCompletionFinalSetup', { clear = true })
  vim.api.nvim_create_autocmd('VimEnter', {
    group = augroup,
    pattern = '*',
    callback = function()
      vim.opt.shortmess:append 'c'
      vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }
    end,
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local bufnr = args.buf
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end

      setup_auto_completion(client, bufnr)

      local comp_aug =
        vim.api.nvim_create_augroup('LspCompDocs' .. bufnr, { clear = true })
      local resolved_cache = {}

      vim.api.nvim_create_autocmd('CompleteChanged', {
        group = comp_aug,
        buffer = bufnr,
        callback = function()
          docs_timer:stop()
          if vim.fn.pumvisible() == 0 then
            return
          end
          local completed_item = vim.v.completed_item
          if
            completed_item.documentation
            and not vim.tbl_isempty(completed_item.documentation)
          then
            local doc = get_docs_from_item(completed_item)
            if doc then
              show_docs_popup(doc)
              return
            end
          end
          local item = vim.tbl_get(
            completed_item,
            'user_data',
            'nvim',
            'lsp',
            'completion_item'
          )
          if not item then
            return
          end
          local key = make_key(item)
          docs_timer:start(
            docs_debounce_ms,
            0,
            vim.schedule_wrap(function()
              client.request(
                'completionItem/resolve',
                item,
                function(err, result)
                  if err then
                    return
                  end
                  local doc = get_docs_from_item(result)
                  if doc then
                    show_docs_popup(doc)
                    resolved_cache[key] = result
                    return
                  end
                  resolved_cache[key] = result
                  local hover_params = vim.lsp.util.make_position_params()
                  client.request(
                    'textDocument/hover',
                    hover_params,
                    function(_, hover)
                      local hdoc = get_hover_docs(hover)
                      if hdoc then
                        show_docs_popup(hdoc)
                        return
                      end
                      client.request(
                        'textDocument/definition',
                        vim.lsp.util.make_position_params(),
                        function(_, def)
                          definition_to_hover(client, bufnr, def)
                        end,
                        bufnr
                      )
                    end,
                    bufnr
                  )
                end,
                bufnr
              )
            end)
          )
        end,
      })

      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
      vim.api.nvim_create_autocmd('CompleteDone', {
        group = comp_aug,
        buffer = bufnr,
        callback = function()
          local ci = vim.v.completed_item
          if
            not (
              ci
              and ci.user_data
              and ci.user_data.nvim
              and ci.user_data.nvim.lsp
              and ci.user_data.nvim.lsp.completion_item
            )
          then
            return
          end
          local item = ci.user_data.nvim.lsp.completion_item
          local key = make_key(item)
          local function apply(edits)
            if not edits or vim.tbl_isempty(edits) then
              return
            end
            local encoding = client and client.offset_encoding or 'utf-16'
            vim.schedule(function()
              pcall(vim.lsp.util.apply_text_edits, edits, bufnr, encoding)
            end)
          end
          local cached = resolved_cache[key]
          if cached then
            if
              cached.additionalTextEdits
              and not vim.tbl_isempty(cached.additionalTextEdits)
            then
              apply(cached.additionalTextEdits)
            end
            if cached.textEdit and type(cached.textEdit) == 'table' then
              apply { cached.textEdit }
            end
            resolved_cache[key] = nil
            return
          end
          client.request('completionItem/resolve', item, function(err, resolved)
            if err or not resolved then
              return
            end
            if
              resolved.additionalTextEdits
              and not vim.tbl_isempty(resolved.additionalTextEdits)
            then
              apply(resolved.additionalTextEdits)
            end
            if resolved.textEdit and type(resolved.textEdit) == 'table' then
              apply { resolved.textEdit }
            end
          end, bufnr)
        end,
      })

      local expr_opts = { noremap = true, silent = true, expr = true }
      vim.api.nvim_buf_set_keymap(
        bufnr,
        'i',
        '<CR>',
        'v:lua.vim.fn.pumvisible() == 1 ? "\\<C-y>" : "\\<CR>"',
        expr_opts
      )
      vim.api.nvim_buf_set_keymap(
        bufnr,
        'i',
        '<Tab>',
        'v:lua.vim.fn.pumvisible() == 1 ? "\\<C-n>" : "\\<Tab>"',
        expr_opts
      )
      vim.api.nvim_buf_set_keymap(
        bufnr,
        'i',
        '<S-Tab>',
        'v:lua.vim.fn.pumvisible() == 1 ? "\\<C-p>" : "\\<S-Tab>"',
        expr_opts
      )
      vim.api.nvim_buf_set_keymap(
        bufnr,
        'i',
        '<C-e>',
        'v:lua.vim.fn.pumvisible() == 1 ? "\\<C-e>" : "\\<End>"',
        expr_opts
      )

      local simple_opts =
        { noremap = true, silent = true, desc = 'Trigger completion' }
      vim.api.nvim_buf_set_keymap(
        bufnr,
        'i',
        '<C-Space>',
        '<C-x><C-o>',
        simple_opts
      )
    end,
  })
end

return M
