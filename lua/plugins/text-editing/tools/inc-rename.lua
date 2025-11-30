local keymaps = function()
    vim.keymap.set('n', 'gR', function()
        return ':IncRename ' .. vim.fn.expand '<cword>'
    end, { expr = true, desc = '[R]ename' })
end

return {
    'smjonas/inc-rename.nvim',

    -- BUG: Without lazy set to false, the plugin never loads
    -- proprely on call
    lazy = false,

    dependencies = { 'folke/noice.nvim' },
    opts = {
        require('noice').setup {
            presets = { inc_rename = true },
        },
    },
    keys = keymaps,
}
