local tools = require 'plugins.ide.tooling'

-- todo: change keymap to respec the <leader>+g... which are "pseudo-lsp" , linters, etc. commands
local keymaps = function()
    vim.keymap.set(
        'n',
        '<leader>ti',
        '<cmd>Inspect<cr>',
        { desc = '[T]reesitter [I]nspect' }
    )
    vim.keymap.set(
        'n',
        '<leader>tI',
        '<cmd>InspectTree<cr>',
        { desc = '[T]reesitter [I]nspect tree' }
    )
end

return { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    keys = keymaps(),
    opts = {
        ensure_installed = tools.parsers,
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
            enable = true,
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            --  If you are experiencing weird indenting issues, add the language to
            --  the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
    },
    -- TODO: There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
