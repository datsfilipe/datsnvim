local map = require("scripts.map")

local opts = { noremap = true, silent = true }

map { "n", "<leader>.", ":luafile %<CR>", opts } -- source config
map { "n", "x", "\"_x", opts }
map { "n", "Q", "<nop>", opts }
map { "i", "<C-c>", "<Esc>", opts } -- the cursed vim keymap
map {
  "n",
  "<leader><leader>",
  function()
    vim.cmd "so"
  end,
  opts,
} -- avoid walking with space
-- zz me daddy
map { "n", "<C-d>", "<C-d>zz", opts }
map { "n", "<C-u>", "<C-u>zz", opts }
map { "n", "{", "{zz", opts }
map { "n", "}", "}zz", opts }
map { "n", "n", "nzzzv", opts }
map { "n", "N", "Nzzzv", opts }
map { "n", "G", "Gzz", opts }
map { "n", "gg", "ggzz", opts }
map { "n", "%", "%zz", opts }
map { "n", "#", "#zz", opts }
-- split screen
map { "n", "<leader>[", ":vsplit<CR>", opts }
map { "n", "<leader>]", ":split<CR>", opts }
-- maximize
map { "n", "<leader>-", "<C-w>_<C-w><Bar>", opts }
map { "n", "<leader>=", "<C-w>=", opts }
-- clipboard / deletion
map { { "n", "v" }, "<leader>y", "\"+y", opts }
map { { "n", "v" }, "<leader>d", "\"_d", opts }
map { "n", "<leader>Y", "gg\"+yG", opts }
map { "x", "<leader>p", "\"_dP", opts } -- keep pasting over the same thing
-- move lines
map { "v", "J", ":m '>+1<CR>gv=gv", opts }
map { "v", "K", ":m '<-2<CR>gv=gv", opts }
map { "n", "<leader>j", ":m .+1<CR>==", opts }
map { "n", "<leader>k", ":m .-2<CR>==", opts }
map { { "n", "i" }, "<A-z>", "<esc>:set wrap!<CR>", opts } -- toggle wrap
-- indent lines
map { "v", "<", "<gv", opts }
map { "v", ">", ">gv", opts }
-- explorer
map { "n", "<leader>e", ":Explore<CR>", opts }
map { "n", "<leader>ve", ":Vexplore<CR>", opts }
map { "n", "<leader>se", ":Sexplore<CR>", opts }
-- cycle tabs
map { "n", ">", ":tabnext<CR>", opts }
map { "n", "<", ":tabprevious<CR>", opts }
map { "n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts } -- rename all occurencies

-- conflict resolutions
-- change increment / decrement binds
map { { "n", "v" }, "<leader>a", "<C-a>", opts } -- C-a is used for tmux
map { { "n", "v" }, "<leader>x", "<C-x>", opts } -- C-x is vim mode in alacritty
map { "v", "<leader>fa", "g<C-a>", opts }
map { "v", "<leader>fx", "g<C-x>", opts }
map { "i", "<Tab>", "<Tab>", opts } -- fix tab conflict between cmp, copilot and default behaviour