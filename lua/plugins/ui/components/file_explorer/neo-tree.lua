-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local keymaps = {
    keys = {
        {
            'tn',
            ':Neotree toggle<CR>',
            desc = 'NeoTree reveal',
            silent = true,
        },
    },
    mappings = {
        ['\\'] = 'close_window',
    },
}

-- TODO: use these symbols instead of the default
-- local symbols = {
--     ['!'] = '!', --     ignored                 !
--     ['?'] = '?', --     untracked               ?
--     ['A'] = '+', --     staged (Added)          A
--     ['C'] = '+c', --    staged (copy)           C
--     ['D'] = '✘', --     deleted                 D
--     ['M'] = '~', --     modified                M
--     ['R'] = '→', --     renamed                 R
--     ['T'] = '', --      typechanged             T
--     ['U'] = '=', --     unmerged (conflict)     U
--     [' '] = '', --      up_to_date (clean)      <space>
-- }

local opts = {
    filesystem = {
        window = {
            mappings = keymaps.mappings,
        },
    },
}

return {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
    },
    lazy = false,
    keys = keymaps.keys,
    opts = opts,
}
