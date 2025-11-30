-- File name: comment-box.lua
-- Author: ovsiankina
-- Date created: 2025-11-30 15:23:10
-- Date modified: 2025-11-30 15:27:34
-- ------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local keymap = function()
    local opts = { noremap = true, silent = true }

    --          ╭─────────────────────────────────────────────────────────╮
    --          │                         Titles                          │
    --          ╰─────────────────────────────────────────────────────────╯
    vim.keymap.set({ 'n', 'v' }, '<Leader>cb', '<Cmd>CBccbox<CR>', opts)
    -- ── Named parts ─────────────────────────────────────────────────────
    vim.keymap.set({ 'n', 'v' }, '<Leader>ct', '<Cmd>CBllline<CR>', opts)
    -- ──────────────────────────────────────────────────────────────────────
    vim.keymap.set('n', '<Leader>cl', '<Cmd>CBline<CR>', opts)
    --                                                           ▲
    --   Marked comments                                         █
    --                                                           ▼
    vim.keymap.set({ 'n', 'v' }, '<Leader>cm', '<Cmd>CBllbox14<CR>', opts)

    -- Removing a box
    vim.keymap.set({ 'n', 'v' }, '<Leader>cd', '<Cmd>CBd<CR>', opts)
end

keymap()

return { 'LudoPinelli/comment-box.nvim' }
