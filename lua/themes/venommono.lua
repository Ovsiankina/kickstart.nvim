-- venommono — monochrome base + a single venom red (#fc302e) accent.
-- Base palette/mapping: lua/lib/monochrome_base.lua (shared with `monochrome`).
-- Red lands on: types/classes/namespaces (incl. Rust traits via LSP), the `fn`
-- keyword (not the name), and bracket/special punctuation. Everything else gray.
-- Tweak the RED list below to personalize. Pure version = the `puremono` theme.

local M = require('lib.monochrome_base')()
local red = '#fc302e' -- black-metal "venom" red

local ts = M.polish_hl.treesitter
local sx = M.polish_hl.syntax

-- types / classes / namespaces (Venom's own red = types) ----------------------
for _, g in ipairs({
  '@type',
  '@type.definition',
  '@type.builtin', -- i32/String etc; drop this line for gray primitives
  '@constructor', -- Foo { .. }
  '@module', -- namespace names: Foo in Foo::bar()
  '@namespace',
  -- LSP semantic tokens (rust-analyzer): traits/structs/enums/classes
  '@lsp.type.class',
  '@lsp.type.struct',
  '@lsp.type.interface', -- traits
  '@lsp.type.enum',
  '@lsp.type.type',
  '@lsp.type.typeAlias',
  '@lsp.type.builtinType',
}) do
  ts[g] = { fg = red }
end

-- your additions (not in venom) ----------------------------------------------
ts['@keyword.function'] = { fg = red } -- the `fn`/`function`/`def` keyword only
ts['@punctuation.bracket'] = { fg = red } -- {} [] ()
ts['@punctuation.special'] = { fg = red } -- ${}, #[ ] interpolation
-- NOTE: @punctuation.delimiter stays gray on purpose — that's where `.` and `::`
-- accessors live, which you wanted gray. Function NAMES stay gray too.

-- non-treesitter / vim-syntax fallbacks (and LSP link targets) ----------------
sx.Type = { fg = red }
sx.Structure = { fg = red }
sx.Special = { fg = red } -- venom reds Special too; drop if too much

M.colors = nil
M = require('base46').override_theme(M, 'venommono')
return M
