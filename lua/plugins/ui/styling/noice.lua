return {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            -- override = {
            --     ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            --     ['vim.lsp.util.stylize_markdown'] = true,
            --     ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
            -- },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            -- set command_palette to false to have the cmdline and popupmenu at
            -- the center of the screen
            command_palette = false, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = true, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
        },
        views = {
            cmdline_popup = {
                border = {
                    style = 'none',
                    padding = { 1, 2 }, -- { height, width }
                },
                position = {
                    -- row = 5,
                    col = '50%',
                },
                filter_options = {},
                win_options = {
                    winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
                },
            },
            popupmenu = {
                relative = 'editor',
                position = {
                    row = 8,
                    col = '50%',
                },
                size = {
                    width = 60,
                    height = 10,
                },
                border = {
                    style = 'none',
                    padding = { 0, 1 },
                },
                -- win_options = {
                --     winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
                -- },
            },
        },
        -- NOTE: '@recording' don't show anymore with noice. We can either use
        -- notify.nvim (cdoe block below)to display these messages or make a
        -- lualine module. (I chose the lualine module.)
        -- routes = {
        --     {
        --         view = 'notify',
        --         filter = { event = 'msg_showmode' },
        --     },
        -- },
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        'MunifTanjim/nui.nvim',
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        'rcarriga/nvim-notify',
    },
}
