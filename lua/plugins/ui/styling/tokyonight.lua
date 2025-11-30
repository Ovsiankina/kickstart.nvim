return {
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        local styles = {
            comments = { italic = false },
        }

        require('tokyonight').setup {
            styles = styles,
        }
        -- Load the colorscheme here.
        -- Like many other themes, this one has different styles, and you could load
        -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
        vim.cmd.colorscheme 'tokyonight-night'
    end,
}
