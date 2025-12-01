-- File name: nvim-highlight-colors.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 18:59:15
-- Date modified: 2025-12-01 19:07:26
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

-- WARN: Virtual symbol is set by NvUI, not nvim-highlight-colors

-- #000000
-- #ffffff
-- #ff0000
-- #00ff00
-- #0000ff

-- Plugin used mainly for the blink intergration
return {
    'brenoprata10/nvim-highlight-colors',
    lazy = true,
    opts = {
        ---Render style
        ---@usage 'background'|'foreground'|'virtual'
        render = 'foreground',
        enable_named_colors = true,
        enable_tailwind = true,
    },
}
