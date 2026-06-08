-- File name: markdown-preview.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 19:10:21
-- Date modified: 2025-12-01 19:11:11
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

-- NOTE: The <leader>mp keymap was moved to after/ftplugin/markdown.lua so it
-- is buffer-local to markdown buffers only (lazy's `keys` spec registered it
-- globally, leaking onto every buffer, e.g. Strudel .str files). The plugin is
-- still lazy-loaded on its commands (cmd) and on the markdown filetype (ft).

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
}
