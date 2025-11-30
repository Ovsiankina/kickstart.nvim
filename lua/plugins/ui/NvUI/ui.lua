-- File name: ui.lua
-- Author: ovsiankina
-- Date created: 2025-11-30 16:11:17
-- Date modified: 2025-11-30 16:12:32
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local keymaps = function()
    vim.keymap.set('n', '<leader>tp', function()
        require('nvchad.themes').open()
    end, { desc = 'Toggle [p]icker' })

    vim.keymap.set(
        'n',
        '<leader>tC',
        '<Cmd>NvCheatsheet<CR>',
        { desc = 'Toggle [C]heatsheet' }
    )
end

return {
    'nvchad/ui',
    config = function()
        require 'nvchad'
        keymaps()
    end,
}
