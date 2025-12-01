-- File name: markdown-preview.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 19:10:21
-- Date modified: 2025-12-01 19:11:11
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local keymaps = {
    {
        '<leader>mp',
        '<cmd>MarkdownPreviewToggle<CR>',
        mode = 'n',
        desc = 'Markdown [p]review',
    },
}

return {
    'iamcco/markdown-preview.nvim',
    cmd = {
        'MarkdownPreviewToggle',
        'MarkdownPreview',
        'MarkdownPreviewStop',
    },
    build = 'cd app && yarn install',
    config = function()
        vim.g.mkdp_filetypes = { 'markdown' }
        vim.g.mkdp_browser = 'zen-browser'
    end,
    ft = { 'markdown' },
    keys = keymaps,
}
