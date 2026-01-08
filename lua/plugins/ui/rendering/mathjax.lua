-- File name: mathjax.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 19:29:54
-- Date modified: 2025-12-04 08:59:39
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

return {
    'SleepySwords/mathjax.nvim',
    -- Replace this with whatever node package manager you use.
    build = 'cd mathjax && yarn install',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        '3rd/image.nvim',
    },
    opts = {},
}
