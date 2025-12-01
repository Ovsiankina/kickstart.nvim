-- File name: rustowl.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 19:30:37
-- Date modified: 2025-12-01 19:33:11
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

---@diagnostic disable-next-line: unused-local
local keymaps = function(client, buffer)
    vim.keymap.set('n', '<leader>to', function()
        require('rustowl').toggle(buffer)
        vim.notify(
            'RustOwl: ' .. tostring(require('rustowl').is_enabled()),
            vim.log.levels.INFO
        )
    end, { buffer = buffer, desc = 'Toggle Rust[o]wl highlight' })
end

return {
    'cordx56/rustowl',
    version = '*', -- Latest stable version
    -- build = 'cargo binstall rustowl',
    ft = 'rust',
    lazy = false, -- This plugin is already lazy
    opts = {
        client = {
            on_attach = function(client, buffer)
                keymaps(client, buffer)
            end,
        },
        highlight_style = 'underline',
        auto_enable = false,
    },
}
--
-- -- event = 'VeryLazy', -- Or `LspAttach`
-- -- event = 'LspAttach', -- Or `VeryLazy`
