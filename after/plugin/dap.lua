local ok, dap = pcall(require, 'dap')
if not ok then
  return
end

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '', linehl = '', numhl = '' })

local dap_vtxt = require 'nvim-dap-virtual-text'
local dap_ui = require 'dapui'

dap_vtxt.setup {
  enabled = true,

  -- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
  enable_commands = true,

  -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_changed_variables = true,
  highlight_new_as_changed = true,

  -- prefix virtual text with comment string
  commented = false,

  show_stop_reason = true,

  -- experimental features:
  virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
  all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
}

dap.defaults.fallback.external_terminal = {
  command = '/usr/bin/alacritty',
}

local map = function(lhs, rhs, desc)
  if desc then
    desc = '[DAP] ' .. desc
  end

  vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
end

-- mappings
map('<F1>', dap.step_back, 'step_back')
map('<F2>', dap.step_into, 'step_into')
map('<F3>', dap.step_over, 'step_over')
map('<F4>', dap.step_out, 'step_out')
map('<F5>', dap.continue, 'continue')

map('<leader>dr', dap.repl.open)

-- You can set trigger characters OR it will default to '.'
-- You can also trigger with the omnifunc, <c-x><c-o>
vim.cmd [[
augroup DapRepl
  au!
  au FileType dap-repl lua require('dap.ext.autocompl').attach()
augroup END
]]

map('<leader>db', dap.toggle_breakpoint)
map('<leader>dB', function()
  dap.set_breakpoint(vim.fn.input '[DAP] Condition > ')
end)

map('<leader>de', require('dapui').eval)
map('<leader>dE', function()
  dap_ui.eval(vim.fn.input '[DAP] Expression > ', vim.fn.line '.')
end)

dap_ui.setup {
  layouts = {
    {
      elements = {
        'scopes',
        'breakpoints',
        'stacks',
        'watches',
      },
      size = 40,
      position = 'left',
    },
    {
      elements = {
        'repl',
        'console',
      },
      size = 10,
      position = 'bottom',
    },
  },
}

local original = {}

local debug_map = function(lhs, rhs, desc)
  local keymaps = vim.api.nvim_get_keymap 'n'
  original[lhs] = vim.tbl_filter(function(v)
    return v.lhs == lhs
  end, keymaps)[1] or true

  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

local debug_unmap = function()
  for k, v in pairs(original) do
    if v == true then
      vim.keymap.del('n', k)
    else
      local rhs = v.rhs

      v.lhs = nil
      v.rhs = nil
      v.buffer = nil
      v.mode = nil
      v.sid = nil
      v.lnum = nil

      vim.keymap.set('n', k, rhs, v)
    end
  end

  original = {}
end

dap.listeners.after.event_initialized['dapui_config'] = function()
  debug_map('asdf', ':echo \'hello world<CR>', 'showing things')

  dap_ui.open {}
end

dap.listeners.before.event_terminated['dapui_config'] = function()
  debug_unmap()

  dap_ui.close {}
end

dap.listeners.before.event_exited['dapui_config'] = function()
  dap_ui.close {}
end

-- setup lldb for rust
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb',
}

dap.configurations.rust = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = '/usr/bin/lldb-vscode',
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    env = function()
      local variables = {}
      for k, v in pairs(vim.fn.environ()) do
        table.insert(variables, string.format('%s=%s', k, v))
      end
      return variables
    end,
  },
}
