local ok, zenmode = pcall(require, "zen-mode")
if not ok then
  return
end

zenmode.setup {}

require "core.keymaps.integrations.zenmode"
