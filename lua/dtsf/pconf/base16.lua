local present, base16 = pcall(require, "base16-colorscheme")
if not present then
  return
end

-- themes
local carbon = {
  base00 = "#161616",
  base01 = "#262626",
  base02 = "#393939",
  base03 = "#525252",
  base04 = "#FDFDFD",
  base05 = "#FAFAFA",
  base06 = "#FFFFFF",
  base07 = "#c1c7cd",
  base08 = "#dde1e6",
  base09 = "#f2f4f8",
  base0A = "#42be65",
  base0B = "#3ddbd9",
  base0C = "#33b1ff",
  base0D = "#ff7eb6",
  base0E = "#be95ff",
  base0F = "#3ddbd9",
}

local jellybeans = {
  base00 = "#151515",
  base01 = "#2e2e2e",
  base02 = "#3a3a3a",
  base03 = "#424242",
  base04 = "#474747",
  base05 = "#d9d9c4",
  base06 = "#dedec9",
  base07 = "#f1f1e5",
  base08 = "#dd785a",
  base09 = "#c99f4a",
  base0A = "#e1b655",
  base0B = "#99ad6a",
  base0C = "#7187af",
  base0D = "#8fa5cd",
  base0E = "#e18be1",
  base0F = "#cf6a4c",
}

local paradise = {
  base00 = "#151515",
  base01 = "#1f1f1f",
  base02 = "#282828",
  base03 = "#3b3b3b",
  base04 = "#e8e3e3",
  base05 = "#e8e3e3",
  base06 = "#e8e3e3",
  base07 = "#e8e3e3",
  base08 = "#b66467",
  base09 = "#d9bc8c",
  base0A = "#d9bc8c",
  base0B = "#8c977d",
  base0C = "#8aa6a2",
  base0D = "#8da3b9",
  base0E = "#a988b0",
  base0F = "#d9bc8c",
}

base16.setup(carbon)

vim.cmd [[
  hi StatusLineNC gui=underline guibg=#161616 guifg=#393939
  hi StatusLine gui=underline guibg=#161616 guifg=#393939

  hi MatchParen gui=underline guibg=#262626

  hi VertSplit guibg=bg guifg=bg

  hi Todo gui=bold
  hi TSSymbol gui=bold
  hi TSFunction gui=bold

  hi EndOfBuffer guifg=background
  hi LineNr guibg=background
  hi SignColumn guibg=background

  hi! link TabLineSel StatusInsert
  hi TabLine guibg=background
  hi TabLineFill guibg=background

  hi FoldColumn guibg=background
  hi DiffAdd guibg=background
  hi DiffChange guibg=background
  hi DiffDelete guibg=background
  hi DiffText guibg=background

  hi CmpItemAbbrMatch gui=bold guifg=#fafafa
  hi CmpItemAbbrMatchFuzzy guifg=#fafafa
  hi CmpItemAbbr guifg=#a8a8a8

  hi CmpItemKindVariable guibg=NONE guifg=#be95ff
  hi CmpItemKindInterface guibg=NONE guifg=#be95ff
  hi CmpItemKindText guibg=NONE guifg=#be95ff
  
  hi CmpItemKindFunction guibg=NONE guifg=#ff7eb6
  hi CmpItemKindMethod guibg=NONE guifg=#ff7eb6

  hi CmpItemKindKeyword guibg=NONE guifg=#33b1ff
  hi CmpItemKindProperty guibg=NONE guifg=#33b1ff
  hi CmpItemKindUnit guibg=NONE guifg=#33b1ff
]]
