-- File name: lazygit.lua
-- Author: ovsiankina
-- Date created: 2025-11-30 15:54:47
-- Date modified: 2025-11-30 16:00:15
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local keymap = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    { '<leader>lc', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit' },
}

return {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
        'LazyGit',
        'LazyGitConfig',
        'LazyGitCurrentFile',
        'LazyGitFilter',
        'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = keymap,
}
