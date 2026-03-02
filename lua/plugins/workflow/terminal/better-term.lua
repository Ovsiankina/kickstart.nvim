local keymaps = {
    {
        '<leader>tt',
        '<cmd>ToggleTerm<CR>',
        desc = 'Toggle terminal',
        mode = { 'n', 't' },
    },
}

return {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = keymaps,
    opts = { --[[ things you want to change go here]]
        shade_terminals = false,
    },
}
