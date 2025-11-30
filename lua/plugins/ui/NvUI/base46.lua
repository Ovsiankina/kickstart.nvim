-- File name: base46.lua
-- Author: ovsiankina
-- Date created: 2025-11-30 16:13:02
-- Date modified: 2025-11-30 16:34:34
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

return {
    'nvchad/base46',
    lazy = false,
    build = function()
        require('base46').load_all_highlights()
    end,
}
