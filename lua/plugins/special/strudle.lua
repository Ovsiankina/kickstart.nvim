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

        vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
            pattern = { '*.str', '*.std' },
            callback = function(ev)
                vim.keymap.set(
                    'n',
                    '<leader>ml',
                    strudel.launch,
                    { buffer = ev.buf, desc = 'Launch Strudel' }
                )
                vim.keymap.set(
                    'n',
                    '<leader>mq',
                    strudel.quit,
                    { buffer = ev.buf, desc = 'Quit Strudel' }
                )
                vim.keymap.set(
                    'n',
                    '<leader>mt',
                    strudel.toggle,
                    { buffer = ev.buf, desc = 'Strudel Toggle Play/Stop' }
                )
                vim.keymap.set(
                    'n',
                    '<leader>mu',
                    strudel.update,
                    { buffer = ev.buf, desc = 'Strudel Update' }
                )
                vim.keymap.set(
                    'n',
                    '<leader>ms',
                    strudel.stop,
                    { buffer = ev.buf, desc = 'Strudel Stop Playback' }
                )
                vim.keymap.set(
                    'n',
                    '<leader>mb',
                    strudel.set_buffer,
                    { buffer = ev.buf, desc = 'Strudel set current buffer' }
                )
                vim.keymap.set(
                    'n',
                    '<leader>mx',
                    strudel.execute,
                    {
                        buffer = ev.buf,
                        desc = 'Strudel set current buffer and update',
                    }
                )
            end,
        })
    end,
}
