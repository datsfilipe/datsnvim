local ok, base16 = pcall(require, "base16-colorscheme")
if not ok then return end

local themed, theme = pcall(require, "theme")

-- Highlights function
local function hl(highlight, fg, bg)
  if fg == nil then fg = "none" end
  if bg == nil then bg = "none" end
  vim.cmd("hi " .. highlight .. " guifg=" .. fg .. " guibg=" .. bg)
end

local present, color = pcall(require, "colors." .. theme)

if themed then
  if present then
    -- Status Line
    hl("StatusLine")
    hl("StatusNormal")
    hl("StatusLineNC", color.base03)
    hl("StatusInactive", color.base03)
    hl("StatusReplace", color.base08)
    hl("StatusInsert", color.base0B)
    hl("StatusCommand", color.base0A)
    hl("StatusVisual", color.base0D)
    hl("StatusTerminal", color.base0E)

    -- Nvim Tree
    hl("NvimTreeFolderName")
    hl("NvimTreeOpenedFolderName")
    hl("NvimTreeEmptyFolderName")
    hl("NvimTreeFolderIcon", color.base03)
    hl("NvimTreeGitDirty", color.base08)
    hl("NvimTreeGitNew", color.base0B)
    hl("NvimTreeGitDeleted", color.base08)
    hl("NvimTreeGitRenamed", color.base0A)
    hl("NvimTreeGitExecFile", color.base0B)
    hl("NvimTreeSpecialFile", color.base0E)
    hl("NvimTreeImageFile", color.base0C)
    hl("NvimTreeWindowPicker", color.base05, color.base01)
    hl("NvimTreeIndentMarker", color.base03)

    -- Telescope
    hl("TelescopePromptBorder", color.base01, color.base01)
    hl("TelescopePromptNormal", nil, color.base01)
    hl("TelescopePromptPrefix", color.base08, color.base01)
    hl("TelescopeSelection", nil, color.base01)

    -- Menu
    hl("Pmenu", nil, color.base01)
    hl("PmenuSbar", nil, color.base01)
    hl("PmenuThumb", nil, color.base01)
    hl("PmenuSel", nil, color.base02)

    -- CMP
    hl("CmpItemAbbrMatch", color.base05)
    hl("CmpItemAbbrMatchFuzzy", color.base05)
    hl("CmpItemAbbr", color.base03)
    hl("CmpItemKind", color.base0E)
    hl("CmpItemMenu", color.base0E)
    hl("CmpItemKindSnippet", color.base0E)

    -- Number
    hl("CursorLine")
    hl("CursorLineNR")
    hl("LineNr", color.base03)

    -- Others
    hl("NormalFloat", nil, color.base01)
    hl("FloatBorder", color.base01, color.base01)
  else
    local ok, err = pcall(vim.cmd, ("colorscheme base16-" .. theme))
    if not ok then
      _G.theme = "paradise-dark"
      color = require("colors." .. _G.theme)
      base16.setup(color)
      print(err)
    end
  end
else
  -- Status Line
  hl("StatusLine")
  hl("StatusNormal")
  hl("StatusLineNC", "#393939")
  hl("StatusInactive", "#393939")
  hl("StatusReplace", "#be95ff")
  hl("StatusInsert", "#ee5396")
  hl("StatusCommand", "#78a9ff")
  hl("StatusVisual", "#42be65")
  hl("StatusTerminal", "#ff7eb6")

  -- Telescope
  hl("TelescopePromptBorder", "#262626", "#161616")
  hl("TelescopePromptNormal", nil, "#161616")
  hl("TelescopePromptPrefix", "#ee5396", "#161616")
  hl("TelescopeSelection", nil, "#161616")

  -- Menu
  hl("Pmenu", nil, "#161616")
  hl("PmenuSbar", nil, "#161616")
  hl("PmenuThumb", nil, "#161616")
  hl("PmenuSel", nil, "#262626")

  -- CMP
  hl("CmpItemAbbrMatch", "#dde1e6")
  hl("CmpItemAbbrMatchFuzzy", "#dde1e6")
  hl("CmpItemAbbr", "#393939")
  hl("CmpItemKind", "#ee5396")
  hl("CmpItemMenu", "#ee5396")
  hl("CmpItemKindSnippet", "#ee5396")

  -- Number
  hl("CursorLine")
  hl("CursorLineNR")
  hl("LineNr", "#393939")

  -- Others
  hl("NormalFloat", nil, "#262626")
  hl("FloatBorder", "#262626", "#262626")
  hl("SignColumn", "#161616")
  hl("Visual", nil, "#525252")
end
