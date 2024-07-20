return {
  'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio',
  },
  keys = {
    {
      '<leader>dt',
      "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
    },
    {
      '<leader>db',
      "<cmd>lua require'dap'.step_back()<cr>",
    },
    {
      '<leader>dc',
      "<cmd>lua require'dap'.continue()<cr>",
    },
    {
      '<leader>dC',
      "<cmd>lua require'dap'.run_to_cursor()<cr>",
    },
    {
      '<leader>dd',
      "<cmd>lua require'dap'.disconnect()<cr>",
    },
    {
      '<leader>dg',
      "<cmd>lua require'dap'.session()<cr>",
    },
    {
      '<leader>di',
      "<cmd>lua require'dap'.step_into()<cr>",
    },
    {
      '<leader>do',
      "<cmd>lua require'dap'.step_over()<cr>",
    },
    {
      '<leader>du',
      "<cmd>lua require'dap'.step_out()<cr>",
    },
    {
      '<leader>dp',
      "<cmd>lua require'dap'.pause()<cr>",
    },
    {
      '<leader>dr',
      "<cmd>lua require'dap'.repl.toggle()<cr>",
    },
    {
      '<leader>ds',
      "<cmd>lua require'dap'.continue()<cr>",
    },
    {
      '<leader>dq',
      "<cmd>lua require'dap'.close()<cr>",
    },
    {
      '<leader>dU',
      "<cmd>lua require'dapui'.toggle({reset = true})<cr>",
    },
  },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'

    local ui_config = {
      icons = { expanded = '+', collapsed = '-', current_frame = '*' },
      controls = {
        icons = {
          pause = 'P',
          play = 'RUN',
          step_into = 'ENTER',
          step_out = 'OUT',
          step_over = '>',
          step_back = '<',
          run_last = 'LAST',
          terminate = 'END',
          disconnect = 'X',
        },
      },
    }
    dapui.setup(ui_config)
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    require('neodev').setup {
      library = { plugins = { 'nvim-dap-ui' }, types = true },
    }
  end,
}
