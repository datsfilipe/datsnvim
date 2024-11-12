vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local methods = vim.lsp.protocol.Methods

    if not client then
      return
    end

    ---Utility for keymap creation.
    local function keymap(lhs, rhs, opts, mode)
      opts = type(opts) == 'string' and { desc = opts }
        or vim.tbl_extend('error', opts, { buffer = bufnr })
      mode = mode or 'n'
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    ---For replacing certain <C-x>... keymaps.
    local function feedkeys(keys)
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(keys, true, false, true),
        'n',
        true
      )
    end

    ---Is the completion menu open?
    local function pumvisible()
      return tonumber(vim.fn.pumvisible()) ~= 0
    end

    -- Enable completion and configure keybindings.
    if client.supports_method(methods.textDocument_completion) then
      -- Configure completion behavior
      vim.opt.completeopt =
        { 'menu', 'menuone', 'noselect', 'preview', 'fuzzy' }

      -- Enable LSP completion
      vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true,
      })

      -- Use enter to accept completions only when menu is visible
      keymap('<cr>', function()
        return pumvisible() and '<C-y>' or '<cr>'
      end, { expr = true }, 'i')

      -- Use <C-e> to dismiss the completion menu
      keymap('<C-e>', function()
        return pumvisible() and '<C-e>' or '<C-e>'
      end, { expr = true }, 'i')

      -- Modified C-n behavior to handle the Blob error
      keymap('<C-n>', function()
        if pumvisible() then
          feedkeys '<C-n>'
        else
          -- Use pcall to handle potential errors
          local ok, _ = pcall(function()
            if next(vim.lsp.get_clients { bufnr = 0 }) then
              vim.lsp.completion.trigger()
            end
          end)

          if not ok then
            if vim.bo.omnifunc == '' then
              feedkeys '<C-x><C-n>'
            else
              feedkeys '<C-x><C-o>'
            end
          end
        end
      end, 'Trigger/select next completion', 'i')

      -- Buffer completions
      keymap('<C-u>', '<C-x><C-n>', { desc = 'Buffer completions' }, 'i')

      -- Tab behavior
      keymap('<Tab>', function()
        if pumvisible() then
          feedkeys '<C-n>'
        elseif vim.snippet.active { direction = 1 } then
          vim.snippet.jump(1)
        else
          feedkeys '<Tab>'
        end
      end, {}, { 'i', 's' })

      keymap('<S-Tab>', function()
        if pumvisible() then
          feedkeys '<C-p>'
        elseif vim.snippet.active { direction = -1 } then
          vim.snippet.jump(-1)
        else
          feedkeys '<S-Tab>'
        end
      end, {}, { 'i', 's' })

      -- Inside a snippet, use backspace to remove the placeholder
      keymap('<BS>', '<C-o>s', {}, 's')
    end
  end,
})
