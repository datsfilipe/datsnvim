local M = {}

local docs_debounce_ms = 300
local timer = vim.loop.new_timer()

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
end

local function setup_auto_completion(_, bufnr)
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
        100,
        0,
        vim.schedule_wrap(function()
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local char_before = col > 0 and line:sub(col, col) or ''
          local word_before = line:sub(1, col):match '%w+$' or ''

          if
            char_before == '.'
            or (#word_before >= 2 and char_before:match '[%w_]')
          then
            trigger_completion()
          end
        end)
      )
    end,
  })

  vim.api.nvim_create_autocmd('InsertCharPre', {
    group = completion_aug,
    buffer = bufnr,
    callback = function()
      local char = vim.v.char
      if char == '.' then
        vim.schedule(trigger_completion)
      end
    end,
  })
end

M.setup = function()
  if not vim.tbl_contains(vim.opt.completeopt:get(), 'menu') then
    vim.opt.completeopt:append 'menu'
  end
  if not vim.tbl_contains(vim.opt.completeopt:get(), 'menuone') then
    vim.opt.completeopt:append 'menuone'
  end
  if not vim.tbl_contains(vim.opt.completeopt:get(), 'noselect') then
    vim.opt.completeopt:append 'noselect'
  end

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local bufnr = args.buf
      if not client then
        return
      end

      vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true,
        trigger_characters = client.server_capabilities.completionProvider
            and client.server_capabilities.completionProvider.triggerCharacters
          or {},
      })

      setup_auto_completion(client, bufnr)

      local aug =
        vim.api.nvim_create_augroup('LspCompDocs' .. bufnr, { clear = true })

      vim.api.nvim_create_autocmd(
        { 'CompleteDone', 'InsertLeave', 'BufLeave', 'LspDetach' },
        {
          group = aug,
          buffer = bufnr,
          callback = function()
            local info = vim.fn.complete_info { 'selected' }
            if info.selected ~= -1 then
              vim.api.nvim__complete_set(info.selected, { info = '' })
            end
          end,
        }
      )

      vim.api.nvim_create_autocmd('CompleteChanged', {
        group = aug,
        buffer = bufnr,
        callback = function()
          timer:stop()
          if vim.fn.pumvisible() == 0 then
            return
          end

          local cid = vim.tbl_get(
            vim.v.completed_item,
            'user_data',
            'nvim',
            'lsp',
            'client_id'
          )
          if cid ~= client.id then
            return
          end

          local item = vim.tbl_get(
            vim.v.completed_item,
            'user_data',
            'nvim',
            'lsp',
            'completion_item'
          )
          if not item then
            return
          end

          local info = vim.fn.complete_info { 'selected' }
          if vim.tbl_isempty(info) or info.selected == -1 then
            return
          end

          if timer then
            timer:start(
              docs_debounce_ms,
              0,
              vim.schedule_wrap(function()
                client.request(
                  'completionItem/resolve',
                  item,
                  ---@diagnostic disable-next-line: param-type-mismatch
                  function(err, result)
                    if err or vim.fn.pumvisible() == 0 then
                      return
                    end

                    local doc = get_docs(result)
                    if not doc then
                      vim.api.nvim__complete_set(info.selected, { info = '' })
                      return
                    end

                    if
                      not vim.tbl_contains(vim.opt.completeopt:get(), 'popup')
                    then
                      vim.opt.completeopt:append 'popup'
                    end

                    local winData =
                      vim.api.nvim__complete_set(info.selected, { info = doc })
                    if vim.api.nvim_win_is_valid(winData.winid) then
                      vim.api.nvim_win_set_config(
                        winData.winid,
                        { border = 'none' }
                      )
                      vim.treesitter.start(winData.bufnr, 'markdown')
                      vim.wo[winData.winid].conceallevel = 3
                    end
                  end,
                  bufnr
                )
              end)
            )
          end
        end,
      })

      local kmopts =
        { buffer = bufnr, noremap = true, silent = true, expr = true }
      vim.keymap.set('i', '<CR>', 'pumvisible() ? "<C-y>" : "<CR>"', kmopts)
      vim.keymap.set('i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"', kmopts)
      vim.keymap.set(
        'i',
        '<S-Tab>',
        'pumvisible() ? "<C-p>" : "<S-Tab>"',
        kmopts
      )
      vim.keymap.set('i', '<C-e>', 'pumvisible() ? "<C-e>" : "<C-e>"', kmopts)

      vim.keymap.set('i', '<C-Space>', function()
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true),
          'n',
          false
        )
      end, { buffer = bufnr, desc = 'Trigger completion' })
    end,
  })
end

return M
