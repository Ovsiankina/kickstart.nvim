-- puremono — pure port of kdheepak/monochrome.nvim (Default style). No accent.
-- (named puremono, not `monochrome`, because base46 ships its own `monochrome`
--  theme which would otherwise shadow this file.)
-- See lua/lib/monochrome_base.lua for the palette + per-group mapping.
-- Sibling: `venommono` = this + venom red. Toggle between them in chadrc.lua.

local M = require('lib.monochrome_base')()
M.colors = nil

M = require('base46').override_theme(M, 'puremono')
return M
