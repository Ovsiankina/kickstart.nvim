return {
    'sustech-data/wildfire.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
        surrounds = {
            { '(', ')' },
            { '{', '}' },
            { '<', '>' },
            { '[', ']' },
        },
        keymaps = {
            init_selection = 'vif',
            node_incremental = '<cr>',
            node_decremental = '<bs>',
        },
    },
}
