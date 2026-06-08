-- File name: render-markdown.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 19:11:13
-- Date modified: 2025-12-01 19:13:10
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

-- NOTE: The <leader>mv and <leader>mf keymaps were moved to
-- after/ftplugin/markdown.lua so they are buffer-local to markdown buffers
-- only (they used to be registered globally here, leaking onto every buffer,
-- e.g. Strudel .str files).

return {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },

    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@type render.md.UserConfig
    opts = {
        completions = { blink = { enabled = true } },
    },
}
