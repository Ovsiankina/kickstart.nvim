-- File name: hardtime.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 19:34:34
-- Date modified: 2025-12-09 08:58:57
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

return {
    'm4xshen/hardtime.nvim',
    dependencies = {
        { 'MunifTanjim/nui.nvim' },
        {
            'antonk52/bad-practices.nvim',
            -- lazy = true,
        },
    },

    -- Setup the plugin. This step is not needed with lazy.nvim if opts is set as above.
    opts = {
        hints = {
            ["k%^"] = {
                message = function()
                    return "Use - instead of k^" -- return the hint message you want to display
                end,
                length = 2,                      -- the length of actual key strokes that matches this pattern
            },

            ["d[tTfF].i"] = {            -- this matches d + {t/T/f/F} + {any character} + i
                message = function(keys) -- keys is a string of key strokes that matches the pattern
                    return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
                    -- example: Use ct( instead of dt(i
                end,
                length = 4,
            },

            -- Use dib instead of di(
            -- Typing b is faster than <Shift>9 or <Shift>0 (for QWERTY user).
            -- https://github.com/m4xshen/hardtime.nvim/discussions/42

            -- use "B" instead of "{":
            ["[dcyvV][ia][%(%)]"] = {
                message = function(keys) return "Use " .. keys:sub(1, 2) .. "b instead of " .. keys end,
                length = 3,
            },
            ["[dcyvV][ia][%{%}]"] = {
                message = function(keys) return "Use " .. keys:sub(1, 2) .. "B instead of " .. keys end,
                length = 3,
            },
        }
    },
}
