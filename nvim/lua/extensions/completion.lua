local M = {}

local docs_debounce_ms = 200
local docs_timer = vim.loop.new_timer()

local function get_docs(result)
  if not result or not result.documentation then
    return nil
  end
  local docs = result.documentation
  if type(docs) == 'table' and docs.value then
    return docs.value
  elseif type(docs) == 'string' then
    return docs
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
            local doc = get_docs(completed_item)
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

          docs_timer:start(
            docs_debounce_ms,
            0,
            vim.schedule_wrap(function()
              client.request(
                'completionItem/resolve',
                item,
                function(err, result)
                  if err or vim.fn.pumvisible() == 0 then
                    return
                  end
                  local doc = get_docs(result)
                  if doc then
                    show_docs_popup(doc)
                  end
                end,
                bufnr
              )
            end)
          )
        end,
      })

      vim.api.nvim_create_autocmd('CompleteDone', {
        group = comp_aug,
        buffer = bufnr,
        callback = function()
          local item = vim.v.completed_item
          if
            item
            and item.user_data
            and item.user_data.nvim
            and item.user_data.nvim.lsp
            and item.user_data.nvim.lsp.completion_item
            and item.user_data.nvim.lsp.completion_item.additionalTextEdits
          then
            vim.lsp.util.apply_text_edits(
              item.user_data.nvim.lsp.completion_item.additionalTextEdits,
              bufnr,
              client.offset_encoding
            )
          end
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
