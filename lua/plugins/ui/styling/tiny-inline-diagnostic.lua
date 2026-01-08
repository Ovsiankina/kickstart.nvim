-- File name: tiny-inline-diagnostic.lua
-- Author: ovsiankina
-- Date created: 2025-11-30 19:02:23
-- Date modified: 2025-12-04 08:53:06
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local opts = {
    -- https://github.com/rachartier/tiny-inline-diagnostic.nvim?tab=readme-ov-file#presets
    preset = 'powerline',
    show_source = true,
    options = {
        multilines = {
            enabled = true,
            always_show = false,
        },
    },
    overflow = {
        mode = 'wrap', -- "wrap": split into lines, "none": no truncation, "oneline": keep single line
        padding = 0,   -- Extra characters to trigger wrapping earlier
    },
    break_line = {
        enabled = true, -- Enable automatic line breaking
        after = 30,     -- Number of characters before inserting a line break
    },
    -- signs = {
    --     left = '',
    --     right = '',
    --     diag = '●',
    --     arrow = '    ',
    --     up_arrow = '    ',
    --     vertical = ' │',
    --     vertical_end = ' └',
    -- },
    -- blend = {
    --     factor = 0.22,
    -- },
}

return {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
        require('tiny-inline-diagnostic').setup(opts)
        vim.diagnostic.config { virtual_text = false } -- Disable Neovim's default virtual text diagnostics
    end,
}
