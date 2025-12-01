-- File name: vim-tmux-navigator.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 17:41:21
-- Date modified: 2025-12-01 17:42:03
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local keymaps = function()
    vim.keymap.set(
        'n',
        'C-h',
        ':TmuxNavigateLeft<CR>',
        { desc = 'Move focus to the left neovim or tmux window' }
    )
    vim.keymap.set(
        'n',
        'C-j',
        ':TmuxNavigateDown<CR>',
        { desc = 'Move focus to the down neovim or tmux window' }
    )
    vim.keymap.set(
        'n',
        'C-k',
        ':TmuxNavigateUp<CR>',
        { desc = 'Move focus to the upper neovim or tmux indow' }
    )
    vim.keymap.set(
        'n',
        'C-l',
        ':TmuxNavigateRight<CR>',
        { desc = 'Move focus to the right neovim or tmux window' }
    )
end

return {
    'christoomey/vim-tmux-navigator',
    keymaps = keymaps(),
}
