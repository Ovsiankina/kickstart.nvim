local function keymaps()
    vim.keymap.set('n', '<leader>nd', function()
        require('noice').cmd 'dismiss'
    end, { desc = '[N]otification [D]ismiss' })
end

return {
    'folke/noice.nvim',
    event = 'VeryLazy',

    keys = keymaps(),
    config = function(_, opts)
        require('noice').setup(opts)

        -- If the prompt stays green, it’s usually because the colorscheme (or theme plugin)
        -- reapplies highlights after Noice is set up. So we set it now *and* on ColorScheme.
        local function set_noice_hls()
            vim.api.nvim_set_hl(0, 'NoiceCmdlinePrompt', { fg = '#ED6D84' })
        end

        set_noice_hls()
        vim.api.nvim_create_autocmd('ColorScheme', {
            group = vim.api.nvim_create_augroup(
                'NoiceHighlights',
                { clear = true }
            ),
            callback = set_noice_hls,
        })
    end,

    opts = {
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            -- override = {
            --   ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            --   ["vim.lsp.util.stylize_markdown"] = true,
            --   ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            -- },
        },

        presets = {
            bottom_search = true,
            command_palette = false,
            long_message_to_split = true,
            inc_rename = true,
            lsp_doc_border = false,
        },

        views = {
            cmdline_popup = {
                border = {
                    style = 'none',
                    padding = { 1, 2 }, -- { height, width }
                },
                position = {
                    col = '50%',
                },
                filter_options = {},
                win_options = {
                    winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
                    winblend = 0, -- non-transparent
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
            },

            -- Route notifications into a Noice popup view (styled like cmdline_popup)
            notify_popup = {
                view = 'cmdline_popup', -- inherit the same style
                position = {
                    row = '50%',
                    col = '100%',
                    anchor = 'SE',
                },
                size = {
                    width = 60,
                    height = 'auto',
                },
                win_options = {
                    winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
                    winblend = 0,
                },
                border = {
                    style = 'none',
                    padding = { 1, 2 },
                },
                timeout = 1000, -- 1.5s (default is 3000)
            },
        },

        routes = {
            -- vim.notify messages
            { filter = { event = 'notify' }, view = 'notify_popup' },

            -- capture yank messages and show them in the same popup
            {
                filter = { event = 'msg_show', find = 'yanked' },
                view = 'notify_popup',
            },
        },
    },

    dependencies = {
        'MunifTanjim/nui.nvim',
        {
            'rcarriga/nvim-notify',
            -- opts = {
            --     render = 'wrapped-compact',
            --     stages = 'fade',
            --     timeout = 100,
            --     top_down = false, -- harmless here; useful if anything still uses nvim-notify
            -- },
        },
    },
}
