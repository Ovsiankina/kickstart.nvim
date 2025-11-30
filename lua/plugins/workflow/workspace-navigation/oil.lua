-- NOTE: configuration: DONE (29.11.25)
local keymaps = {
    global = function()
        vim.keymap.set(
            'n',
            '<leader>b',
            -- BUG: preview copies instead of moving
            -- https://github.com/stevearc/oil.nvim/issues/632
            -- '<CMD>Oil --preview<CR>',
            '<CMD>Oil <CR>',
            { desc = 'Open parent directory' }
        )
    end,

    -- BUG: seems like these maps aren't passed proprely
    in_oil = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        -- ["<C-V>"] = "actions.select_vsplit",
        -- ['<C-S>'] = 'actions.select_split',
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = 'actions.close',
        ['<C-r>'] = 'actions.refresh',
        ['<leader>b'] = 'actions.parent',
        ['-'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = 'actions.tcd',
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['gt'] = 'actions.toggle_trash',
        -- TODO: find how to disable these proprely
        -- ['<C-h>'] = false,
        -- ['<C-j>'] = false,
        -- ['<C-k>'] = false,
        -- ['<C-l>'] = false,
    },
}

local symbols = {
    ['!'] = '!', --     ignored                 !
    ['?'] = '?', --     untracked               ?
    ['A'] = '+', --     staged (Added)          A
    ['C'] = '+c', --    staged (copy)           C
    ['D'] = '✘', --     deleted                 D
    ['M'] = '~', --     modified                M
    ['R'] = '→', --     renamed                 R
    ['T'] = '', --      typechanged             T
    ['U'] = '=', --     unmerged (conflict)     U
    [' '] = '', --      up_to_date (clean)      <space>
}

local opts = {
    default_file_explorer = true,

    columns = {
        'icon',
        -- "permissions",
        -- 'size',
        -- "mtime",
    },

    win_options = {
        wrap = false,
        signcolumn = 'yes:2', -- yes:2 is required for 'oil-git-status'.
        cursorcolumn = false,
        foldcolumn = '0',
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = 'nvic',
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = false,
    prompt_save_on_select_new_entry = true,

    lsp_file_methods = {
        -- Enable or disable LSP file operations
        enabled = true,
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 3000, -- default: 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = false,
    },

    use_default_keymaps = true,
    view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        -- This function defines what is considered a "hidden" file
        ---@diagnostic disable-next-line: unused-local
        is_hidden_file = function(name, bufnr)
            local m = name:match '^%.'
            return m ~= nil
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        ---@diagnostic disable-next-line: unused-local
        is_always_hidden = function(name, bufnr)
            return false
        end,
        -- Sort file names with numbers in a more intuitive order for humans.
        -- Can be "fast", true, or false. "fast" will turn it off for large directories.
        natural_order = 'fast',
        -- Sort file and directory names case insensitive
        case_insensitive = false,
        sort = {
            -- sort order can be "asc" or "desc"
            -- see :help oil-columns to see which columns are sortable
            { 'type', 'asc' },
            { 'name', 'asc' },
        },
        -- Customize the highlight group for the file name
        -- highlight_filename = function(
        --     entry,
        --     is_hidden,
        --     is_link_target,
        --     is_link_orphan
        -- )
        --     return nil
        -- end,
        use_default_keymaps = false,
        keymaps = keymaps.in_oil,
    },
}

keymaps.global()
return {
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@diagnostic disable-next-line: undefined-doc-name
        ---@type oil.SetupOpts
        -- Optional dependencies
        dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
        opts = opts,
    },
    {
        'refractalize/oil-git-status.nvim',

        dependencies = {
            'stevearc/oil.nvim',
        },

        config = true,

        opts = {
            show_ignored = true, -- show files that match gitignore with !!
            -- customize the symbols that appear in the git status columns
            symbols = {
                index = symbols,
                working_tree = symbols,
            },
        },
    },
    {
        'benomahony/oil-git.nvim',
        dependencies = { 'stevearc/oil.nvim' },
        -- No opts or config needed! Works automatically
    },
    {
        'JezerM/oil-lsp-diagnostics.nvim',
        dependencies = { 'stevearc/oil.nvim' },
        opts = {},
    },
}
