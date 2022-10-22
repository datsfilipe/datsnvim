local status, colors = pcall(require, 'lsp-colors')
if (not status) then return end

colors.setup {
}
