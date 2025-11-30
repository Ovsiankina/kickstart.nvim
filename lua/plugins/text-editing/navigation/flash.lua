local keymaps = {
    {
        '<leader>s',
        mode = { 'n', 'x', 'o' },
        function()
            require('flash').jump()
        end,
        desc = '[S]earch in current buffer with Flash',
    },
    {
        '<leader>v',
        mode = { 'n', 'x', 'o' },
        function()
            require('flash').treesitter()
        end,
        desc = 'Select Blocks with Flash Treesitter',
    },
}

return {
    'folke/flash.nvim',
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@type Flash.Config
    opts = {},
    keys = keymaps,
}
