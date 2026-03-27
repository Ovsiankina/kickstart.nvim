local keymaps = {
    {
        '<leader>co',
        '<Cmd>CompilerOpen<CR>',
        desc = 'Compiler [o]open',
    },
    -- {
    --     '<leader>co',
    --     '<Cmd>CompilerToggleResults<CR>',
    --     desc = '[co]mpiler result',
    -- },
}

return {
    'Zeioth/compiler.nvim',
    cmd = { 'CompilerOpen', 'CompilerToggleResults', 'CompilerRedo' },
    dependencies = { 'stevearc/overseer.nvim', 'nvim-telescope/telescope.nvim' },
    keys = keymaps,
    opts = {},
}
