local ok, hlchunk = pcall(require, "hlchunk")
if not ok then
  return
end

vim.cmd [[highlight IndentLineChar guifg=#343434 gui=nocombine]]

hlchunk.setup {
  blank = {
    enable = false,
    notify = false,
  },
  chunk = {
    enable = false,
    notify = false,
  },
  indent = {
    enable = true,
    style = {
      vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID "IndentLineChar"), "fg", "gui"),
    },
  },
  line_num = { enable = false },
}
