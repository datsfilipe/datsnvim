local keymap = vim.keymap

keymap.set("n", "<leader>dt", "<cmd>lua require('dapui').toggle()<CR>")
keymap.set("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>")
keymap.set("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>")
keymap.set("n", "<leader>dr", "<cmd>lua require('dap').repl.toggle()<CR>")

-- define symbols
vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapUIStop', numhl = 'DapUIStop' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapUIType', numhl = 'DapUIType' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapUIFloaty', numhl = 'DapUIFloaty' })
vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapUIType', numhl = 'DapUIType' })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapUIFloaty', numhl = 'DapUIFloaty' })

return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        event = "BufEnter",
        opts = { automatic_installation = true }
      },
      { "rcarriga/nvim-dap-ui",            event = "BufEnter", opts = {} },
      { "theHamsta/nvim-dap-virtual-text", event = "BufEnter", opts = {} },
    },
  },
}
