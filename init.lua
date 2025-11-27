--[[
=====================================================================
=====================================================================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||  OVSIANKINA.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ allowed  \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================
=====================================================================
--]]

-- [[ Internal modules ]]
--
-- The paths read as follows:
-- `require 'config.vim'.global()` -> 'config.vim' = ./lua/config/vim.lua
-- `require 'lazy'.install()` -> 'lazy' = ./lua/lazy.lua

-- Nvim API configuration and utilities
require('settings.vim').global()
require('settings.vim').options()
require('settings.vim').keymaps()
require('settings.vim').autocommand()

-- Lazy.nvim plugin manager
require('plugin-manager').install()
require('plugin-manager').plugins()
-- require('lua.plugins.ide.mason').setup()

vim.keymap.set(
    'n',
    '<leader>b',
    '<CMD>Oil<CR>',
    { desc = 'Open parent directory' }
)

-- -- The line beneath this is called `modeline`. See `:help modeline`
-- -- vim: ts=2 sts=2 sw=2 et
