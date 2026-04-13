-- File name: nvim-surround.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 17:43:39
-- Date modified: 2025-12-01 18:50:24
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

--[[
    Old text                    Command         New text
--------------------------------------------------------------------------------
    surr*ound_words             ysiw)           (surround_words)
    surr*ound_words             ysiw(           ( surround_words )
    *make strings               ys$"            "make strings"
    [delete ar*ound me!]        ds]             delete around me!
    remove <b>HTML t*ags</b>    dst             remove HTML tags
    'change quot*es'            cs'"            "change quotes"
    <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    delete(functi*on calls)     dsf             function calls
--]]

-- Disable default mappings (set via <Plug> below instead)
vim.g.nvim_surround_no_insert_mappings = true
vim.g.nvim_surround_no_normal_mappings = true
vim.g.nvim_surround_no_visual_mappings = true

local keymaps = {
    {
        mode = 'i',
        lhs = '<C-g>s',
        rhs = '<Plug>(nvim-surround-insert)',
        desc = 'Add surrounding (insert)',
    },
    {
        mode = 'i',
        lhs = '<C-g>S',
        rhs = '<Plug>(nvim-surround-insert-line)',
        desc = 'Add surrounding line (insert)',
    },
    {
        mode = 'n',
        lhs = 'ys',
        rhs = '<Plug>(nvim-surround-normal)',
        desc = 'Add surrounding around motion',
    },
    {
        mode = 'n',
        lhs = 'yss',
        rhs = '<Plug>(nvim-surround-normal-cur)',
        desc = 'Add surrounding around current line',
    },
    {
        mode = 'n',
        lhs = 'yS',
        rhs = '<Plug>(nvim-surround-normal-line)',
        desc = 'Add surrounding around motion (line)',
    },
    {
        mode = 'n',
        lhs = 'ySS',
        rhs = '<Plug>(nvim-surround-normal-cur-line)',
        desc = 'Add surrounding around current line (line)',
    },
    {
        mode = 'x',
        lhs = 'S',
        rhs = '<Plug>(nvim-surround-visual)',
        desc = 'Add surrounding (visual)',
    },
    {
        mode = 'x',
        lhs = 'gS',
        rhs = '<Plug>(nvim-surround-visual-line)',
        desc = 'Add surrounding (visual line)',
    },
    {
        mode = 'n',
        lhs = 'ds',
        rhs = '<Plug>(nvim-surround-delete)',
        desc = 'Delete surrounding pair',
    },
    {
        mode = 'n',
        lhs = 'cs',
        rhs = '<Plug>(nvim-surround-change)',
        desc = 'Change surrounding pair',
    },
    {
        mode = 'n',
        lhs = 'cS',
        rhs = '<Plug>(nvim-surround-change-line)',
        desc = 'Change surrounding pair (line)',
    },
}

return {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
        require('nvim-surround').setup {}

        for _, map in ipairs(keymaps) do
            vim.keymap.set(map.mode, map.lhs, map.rhs, { desc = map.desc })
        end
    end,
}
