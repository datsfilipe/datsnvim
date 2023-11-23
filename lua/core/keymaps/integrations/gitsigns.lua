local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
  return
end

local keymap = vim.keymap

return function()
  keymap.set("n", "<leader>gs", ":Gitsigns stage_hunk<CR>")
  keymap.set("n", "<leader>gr", ":Gitsigns reset_hunk<CR>")
  keymap.set("v", "<leader>gs", ":Gitsigns stage_hunk<CR>")
  keymap.set("v", "<leader>gr", ":Gitsigns reset_hunk<CR>")
  keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk)
  keymap.set(
    "n",
    "<leader>gb",
    function()
      gitsigns.blame_line { full = true }
    end
  )
end
