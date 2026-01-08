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

-- Load base46 cache (must be called before lazy setup)
vim.g.base46_cache = vim.fn.stdpath 'data' .. '/base46_cache/'

-- Lazy.nvim plugin manager
-- TODO: automate MASON tools and LAZY updates
require('plugin-manager').install()
require('plugin-manager').plugins()

-- Load all highlights at once
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end

-- -- The line beneath this is called `modeline`. See `:help modeline`
-- -- vim: ts=2 sts=2 sw=2 et
