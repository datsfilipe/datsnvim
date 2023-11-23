local discipline = require "custom.discipline"
discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("i", "<C-c>", "<Esc>", opts)
keymap.set("n", "x", '"_x')

-- avoid walking with space
keymap.set("n", "<leader><leader>", function() vim.cmd "so" end, opts)

-- increment/decrement
keymap.set({ "n", "v" }, "+", "<C-a>")
keymap.set({ "n", "v" }, "-", "<C-x>")
keymap.set("v", "g+", "g<C-a>", opts)
keymap.set("v", "g-", "g<C-x>", opts)

-- move lines
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
keymap.set("n", "<leader>j", ":m .+1<CR>==", opts)
keymap.set("n", "<leader>k", ":m .-2<CR>==", opts)

-- go back to last edited line
keymap.set("n", "g;", "`[", opts)

-- disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- new tab
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", ">", ":tabnext<Return>", opts)
keymap.set("n", "<", ":tabprev<Return>", opts)
-- split window
keymap.set("n", "<leader>]", ":split<Return>", opts)
keymap.set("n", "<leader>[", ":vsplit<Return>", opts)
-- maximize window
keymap.set("n", "<leader>-", "<C-w>_<C-w><Bar>", opts)
-- equalize windows
keymap.set("n", "<leader>=", "<C-w>=", opts)

-- wrap lines
keymap.set("n", "<A-z>", ":set wrap!<Return>", opts)
-- indent lines
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- netrw
keymap.set("n", "<leader>e", ":Explore<Return>", opts)
keymap.set("n", "<leader>s", ":Sexplore<Return>", opts)

-- replace occurences
keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)
keymap.set("v", "<leader>r", ":%s/<C-r><C-w>//gc<Left><Left><Left>", opts)

-- copy all
keymap.set("n", "<leader>Y", "ggVG\"+y", opts)
-- copy to clipboard
keymap.set({ "n", "v" }, "<leader>y", [["+y]], opts)

-- delete but don't yank
keymap.set({ "n", "v" }, "<leader>d", [["_d]], opts)
-- paste but don't yank the deleted text
keymap.set("x", "<leader>p", [["_dP]], opts)

-- diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

keymap.set("n", "<C-k>", function()
  vim.diagnostic.goto_prev()
end, opts)

-- make file executable
keymap.set("n", "<leader>x", ":!chmod +x %<Return>", opts)

-- tmux-sessionizer (https://github.com/datsfilipe/unix-scripts/blob/main/tmux-sessionizer)
keymap.set("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<Return>", opts)
