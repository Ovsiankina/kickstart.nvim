local tools = require 'plugins.ide.tooling'

-- todo: change keymap to respec the <leader>+g... which are "pseudo-lsp" , linters, etc. commands
local keymaps = function()
    vim.keymap.set(
        'n',
        '<leader>gi',
        '<cmd>Inspect<cr>',
        { desc = 'Treesitter [I]nspect' }
    )
    -- vim.keymap.set(
    --     'n',
    --     '<leader>gI',
    --     '<cmd>InspectTree<cr>',
    --     { desc = 'Treesitter [I]nspect tree' }
    -- )
end

return { -- Highlight, edit, and navigate code
    'neovim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = { 'neovim-treesitter/treesitter-parser-registry' },
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    keys = keymaps(),
    config = function()
        -- New fork: setup only accepts install_dir / local_parsers
        require('nvim-treesitter').setup()

        -- Install parsers (equivalent to old ensure_installed)
        require('nvim-treesitter.install').install(tools.parsers)

        -- Highlighting and indent are now handled by built-in nvim treesitter.
        -- Enable highlight for all filetypes that have a parser.
        vim.api.nvim_create_autocmd('FileType', {
            callback = function(ev)
                local ok = pcall(vim.treesitter.start, ev.buf)
                if not ok then return end
                -- Use treesitter-based indent when available
                vim.bo[ev.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
            end,
        })
    end,
    -- TODO: There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
