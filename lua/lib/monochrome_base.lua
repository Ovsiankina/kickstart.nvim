-- monochrome_base — shared base for the `puremono` and `venommono` themes.
-- Faithful port of kdheepak/monochrome.nvim (Default style). Palette computed by
-- monochrome's own util.colorize(fg='#EBEBEB', bg='#101010') — HSLuv grays, not guessed.
-- Returns a BUILDER so each theme gets a fresh, independent table (no shared mutation).
-- `puremono.lua`   = pure (this, untouched).
-- `venommono.lua`  = this + venom red baked onto type/punct/fn groups.

return function()
  -- real monochrome.nvim Default palette
  local c = {
    bg = '#0e0e0e',
    bg_alt = '#191919',
    fg = '#eeeeee',
    fg_alt = '#e1e1e1',
    gray1 = '#222222',
    gray2 = '#353535',
    gray3 = '#494949',
    gray4 = '#5e5e5e',
    gray5 = '#747474',
    gray6 = '#8b8b8b',
    gray7 = '#a3a3a3',
    gray8 = '#bbbbbb',
    gray9 = '#d4d4d4',
  }

  local M = { colors = c }

  M.base_30 = {
    white = c.fg,
    darker_black = '#080808',
    black = c.bg, --  nvim bg (#0e0e0e)
    black2 = '#151515',
    one_bg = c.bg_alt,
    one_bg2 = '#1f1f1f',
    one_bg3 = c.gray1,
    grey = c.gray2,
    grey_fg = c.gray3, -- comments
    grey_fg2 = c.gray4,
    light_grey = c.gray4,
    red = c.gray6,
    baby_pink = c.gray6,
    pink = c.gray6,
    line = '#1f1f1f',
    green = c.gray6,
    vibrant_green = c.gray6,
    nord_blue = c.gray7,
    blue = c.gray7,
    yellow = c.gray7,
    sun = c.gray7,
    purple = c.gray7,
    dark_purple = c.gray6,
    teal = c.gray6,
    orange = c.gray7,
    cyan = c.gray6,
    statusline_bg = '#0b0b0b',
    lightbg = '#1f1f1f',
    pmenu_bg = c.gray6,
    folder_bg = c.gray7,
  }

  M.base_16 = {
    base00 = c.bg,
    base01 = '#151515',
    base02 = c.bg_alt,
    base03 = c.gray3, -- comments
    base04 = c.gray4,
    base05 = c.fg, -- default fg / operators / punctuation
    base06 = c.fg_alt,
    base07 = c.gray9,
    base08 = c.gray7, -- params
    base09 = c.fg, -- numbers / constants
    base0A = c.gray4, -- types / attrs
    base0B = c.gray9, -- strings
    base0C = c.gray9, -- string escape
    base0D = c.gray6, -- functions
    base0E = c.gray4, -- keywords
    base0F = c.gray2, -- punctuation special / deprecated
  }

  M.type = 'dark'

  -- exact per-group reproduction of monochrome/theme.lua
  M.polish_hl = {
    treesitter = {
      -- variables / fields / params
      ['@variable'] = { fg = c.gray8 },
      ['@variable.builtin'] = { fg = c.gray8 },
      ['@variable.parameter'] = { fg = c.gray7 },
      ['@variable.member'] = { fg = c.gray5 },
      ['@variable.member.key'] = { fg = c.gray5 },
      ['@property'] = { fg = c.gray5 },
      ['@field'] = { fg = c.gray5 },
      -- modules / namespaces
      ['@module'] = { fg = c.gray4 },
      ['@namespace'] = { fg = c.gray4 },
      -- constants / numbers / literals
      ['@constant'] = { fg = c.fg },
      ['@constant.builtin'] = { fg = c.gray3 },
      ['@constant.macro'] = { fg = c.fg },
      ['@number'] = { fg = c.fg, bold = true },
      ['@number.float'] = { fg = c.fg, bold = true },
      ['@boolean'] = { fg = c.fg, bold = true },
      ['@float'] = { fg = c.fg, bold = true },
      ['@character'] = { fg = c.fg },
      ['@constructor'] = { fg = c.fg },
      -- strings
      ['@string'] = { fg = c.gray9 },
      ['@string.regex'] = { fg = c.gray9 },
      ['@string.regexp'] = { fg = c.gray9 },
      ['@string.escape'] = { fg = c.gray9 },
      -- keywords / conditionals / repeat
      ['@keyword'] = { fg = c.gray4 },
      ['@keyword.function'] = { fg = c.gray4 },
      ['@keyword.operator'] = { fg = c.gray4 },
      ['@keyword.return'] = { fg = c.gray4 },
      ['@keyword.conditional'] = { fg = c.gray4 },
      ['@keyword.conditional.ternary'] = { fg = c.gray4 },
      ['@keyword.repeat'] = { fg = c.gray4 },
      ['@keyword.exception'] = { fg = c.gray4 },
      ['@keyword.storage'] = { fg = c.gray4 },
      ['@conditional'] = { fg = c.gray4 },
      ['@repeat'] = { fg = c.gray4 },
      ['@exception'] = { fg = c.gray4 },
      -- includes / imports
      ['@keyword.import'] = { fg = c.gray7 },
      ['@include'] = { fg = c.gray7 },
      -- functions / methods; builtins gray4
      ['@function'] = { fg = c.gray6 },
      ['@function.call'] = { fg = c.gray6 },
      ['@function.method'] = { fg = c.gray6 },
      ['@function.method.call'] = { fg = c.gray6 },
      ['@function.macro'] = { fg = c.gray6 },
      ['@function.builtin'] = { fg = c.gray4 },
      ['@method'] = { fg = c.gray6 },
      -- operators / punctuation
      ['@operator'] = { fg = c.fg },
      ['@punctuation.bracket'] = { fg = c.fg },
      ['@punctuation.delimiter'] = { fg = c.fg },
      ['@punctuation.special'] = { fg = c.fg },
      ['@label'] = { fg = c.fg },
      ['@symbol'] = { fg = c.fg },
      ['@tag'] = { fg = c.fg },
      ['@tag.delimiter'] = { fg = c.fg },
      ['@tag.attribute'] = { fg = c.gray7 },
      ['@text'] = { fg = c.fg },
      -- types
      ['@type'] = { fg = c.gray4 },
      ['@type.builtin'] = { fg = c.gray4 },
      ['@type.definition'] = { fg = c.gray7 },
      ['@attribute'] = { fg = c.gray7 },
      -- comments
      ['@comment'] = { fg = c.gray3, italic = true },
      ['@comment.documentation'] = { fg = c.gray3, italic = true },

      -- LSP semantic tokens (base46 leaves these unpinned -> they leaked
      -- tokyonight's cyan onto traits). Pin every one to a gray so the pure
      -- theme stays monochrome even with rust-analyzer attached.
      ['@lsp.type.class'] = { fg = c.gray4 },
      ['@lsp.type.struct'] = { fg = c.gray4 },
      ['@lsp.type.interface'] = { fg = c.gray4 }, -- traits
      ['@lsp.type.enum'] = { fg = c.gray4 },
      ['@lsp.type.type'] = { fg = c.gray4 },
      ['@lsp.type.builtinType'] = { fg = c.gray4 },
      ['@lsp.type.typeAlias'] = { fg = c.gray7 },
      ['@lsp.type.typeParameter'] = { fg = c.gray7 },
      ['@lsp.type.namespace'] = { fg = c.gray4 },
      ['@lsp.type.property'] = { fg = c.gray5 },
      ['@lsp.type.parameter'] = { fg = c.gray7 },
      ['@lsp.type.variable'] = { fg = c.gray8 },
      ['@lsp.type.function'] = { fg = c.gray6 },
      ['@lsp.type.method'] = { fg = c.gray6 },
      ['@lsp.type.macro'] = { fg = c.gray6 },
      ['@lsp.type.decorator'] = { fg = c.gray6 },
      ['@lsp.type.enumMember'] = { fg = c.fg },
      ['@lsp.type.lifetime'] = { fg = c.gray4 },
      ['@lsp.type.keyword'] = { fg = c.gray4 },
      ['@lsp.type.comment'] = { fg = c.gray3, italic = true },
      ['@lsp.type.string'] = { fg = c.gray9 },
      ['@lsp.type.number'] = { fg = c.fg, bold = true },
      ['@lsp.type.operator'] = { fg = c.fg },
    },

    syntax = {
      Comment = { fg = c.gray3, italic = true },
      String = { fg = c.gray9 },
      Character = { fg = c.fg },
      Number = { fg = c.fg, bold = true },
      Float = { fg = c.fg, bold = true },
      Boolean = { fg = c.fg, bold = true },
      Constant = { fg = c.fg },
      Identifier = { fg = c.gray8 },
      Function = { fg = c.gray6 },
      Statement = { fg = c.gray4 },
      Keyword = { fg = c.gray4 },
      Conditional = { fg = c.gray4 },
      Repeat = { fg = c.gray4 },
      Operator = { fg = c.fg },
      Type = { fg = c.gray4 },
      Structure = { fg = c.gray4 },
      Typedef = { fg = c.gray7 },
      PreProc = { fg = c.gray4 },
      Include = { fg = c.gray7 },
      Define = { fg = c.gray3 },
      Macro = { fg = c.gray6 },
      Special = { fg = c.fg },
      Delimiter = { fg = c.fg },
      Label = { fg = c.fg },
    },

    defaults = {
      -- monochrome inverts the selection: dark text on light block (very visible)
      Visual = { fg = c.bg, bg = c.fg },
      VisualNOS = { fg = c.bg, bg = c.fg },
      CursorLine = { bg = c.bg_alt },
      MatchParen = { bold = true },
    },
  }

  return M
end
