-- File name: nvim-surround.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 17:43:39
-- Date modified: 2025-12-01 18:50:24
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

-- TODO: use vim api to set keymaps so that descriptions can be added

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
local keymaps = {
    insert = '<C-g>s',
    insert_line = '<C-g>S',
    normal = 'ys',
    normal_cur = 'yss',
    normal_line = 'yS',
    normal_cur_line = 'ySS',
    visual = 'S',
    visual_line = 'gS',
    delete = 'ds',
    change = 'cs',
    change_line = 'cS',
}

return {
    'kylechui/nvim-surround',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
        require('nvim-surround').setup {
            -- Configuration here, or leave empty to use defaults
            keymaps = keymaps,
        }
    end,
}
