-- File name: yanky.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 18:52:45
-- Date modified: 2025-12-01 18:58:25
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

-- TODO: study yanky.nvim opts (ring, highlight, clipboard sync) and finalize keymaps

local function keymaps()
    -- vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
    vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
    vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
    vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')

    vim.keymap.set('n', '<c-p>', '<Plug>(YankyPreviousEntry)')
    vim.keymap.set('n', '<c-n>', '<Plug>(YankyNextEntry)')
end
keymaps()

return {
    'gbprod/yanky.nvim',
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
}
