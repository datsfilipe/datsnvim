local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- comment plugin
keymap.set("n", "<leader>/", "<cmd>lua require(\"Comment.api\").toggle.linewise.current()<CR>", opts)
keymap.set("v", "<leader>/", "<ESC><cmd>lua require(\"Comment.api\").toggle.linewise(vim.fn.visualmode())<CR>", opts)

-- diffview plugin
keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", opts)
keymap.set("n", "<leader>gx", ":DiffviewClose<CR>", opts)
keymap.set("n", "<leader>ge", ":DiffviewToggleFiles<CR>", opts)
keymap.set("n", "<leader>gr", ":DiffviewRefresh<CR>", opts)
keymap.set("n", "<leader>gs", ":DiffviewToggleFiles<CR>", opts)

-- neogit plugin
keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", opts)

-- markdown preview plugin
keymap.set("n", "<F12>", "<cmd>MarkdownPreviewToggle<CR>", opts)
