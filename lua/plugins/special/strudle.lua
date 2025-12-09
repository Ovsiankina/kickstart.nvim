-- File name: strudle.lua
-- Author: ovsiankina
-- Date created: 2025-12-06 18:36:50
-- Date modified: 2025-12-06 19:14:38
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

return {
    'gruvw/strudel.nvim',
    build = 'npm ci',
    config = function()
        require('strudel').setup {
            update_on_save = true,
            ui = {},
        }

        local strudel = require 'strudel'

        vim.keymap.set(
            'n',
            '<leader>ml',
            strudel.launch,
            { desc = 'Launch Strudel' }
        )
        vim.keymap.set(
            'n',
            '<leader>mq',
            strudel.quit,
            { desc = 'Quit Strudel' }
        )
        vim.keymap.set(
            'n',
            '<leader>mt',
            strudel.toggle,
            { desc = 'Strudel Toggle Play/Stop' }
        )
        vim.keymap.set(
            'n',
            '<leader>mu',
            strudel.update,
            { desc = 'Strudel Update' }
        )
        vim.keymap.set(
            'n',
            '<leader>ms',
            strudel.stop,
            { desc = 'Strudel Stop Playback' }
        )
        vim.keymap.set(
            'n',
            '<leader>mb',
            strudel.set_buffer,
            { desc = 'Strudel set current buffer' }
        )
        vim.keymap.set(
            'n',
            '<leader>mx',
            strudel.execute,
            { desc = 'Strudel set current buffer and update' }
        )
    end,
}
