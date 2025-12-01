-- File name: blink.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 19:13:38
-- Date modified: 2025-12-01 19:15:44
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local keymaps = {

    -- 'default' (recommended) for mappings similar to built-in completions
    --   <c-y> to accept ([y]es) the completion.
    --    This will auto-import if your LSP supports it.
    --    This will expand snippets if the LSP sent a snippet.
    -- 'super-tab' for tab to accept
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- For an understanding of why the 'default' preset is recommended,
    -- you will need to read `:help ins-completion`
    --
    -- TODO: No, but seriously. Please read `:help ins-completion`, it is really good!
    --
    -- All presets have the following mappings:
    -- <tab>/<s-tab>: move to right/left of your snippet expansion
    -- <c-space>: Open menu or open docs if already open
    -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
    -- <c-e>: Hide menu
    -- <c-k>: Toggle signature help
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    --
    -- recap of chapter: Insert mode completion				*ins-completion*
    --
    -- 1. Whole lines						            |i_CTRL-X_CTRL-L|
    -- 2. keywords in the current file		            |i_CTRL-X_CTRL-N|
    -- 3. keywords in 'dictionary'				        |i_CTRL-X_CTRL-K|
    -- 4. keywords in 'thesaurus', thesaurus-style		|i_CTRL-X_CTRL-T|
    -- 5. keywords in the current and included files	|i_CTRL-X_CTRL-I|
    -- 6. tags							                |i_CTRL-X_CTRL-]|
    -- 7. file names						            |i_CTRL-X_CTRL-F|
    -- 8. definitions or macros				            |i_CTRL-X_CTRL-D|
    -- 9. Vim command-line					            |i_CTRL-X_CTRL-V|
    -- 10. User defined completion			            |i_CTRL-X_CTRL-U|
    -- 11. omni completion					            |i_CTRL-X_CTRL-O|
    -- 12. Spelling suggestions				            |i_CTRL-X_s|
    -- 13. keywords in 'complete'			            |i_CTRL-N| |i_CTRL-P|
    preset = 'default',

    ['<C-k>'] = { 'select_prev', 'fallback' },
    ['<C-j>'] = { 'select_next', 'fallback' },

    ['<C-f>'] = { 'accept', 'fallback' },

    ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },

    -- disable a keymap from the preset
    -- ['<C-e>'] = false, -- or {}

    -- show with alist of providers
    ['<C-space>'] = {
        function(cmp)
            cmp.show { providers = { 'snippets' } }
        end,
    },

    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
}

local draw_highlight_colors = {
    components = {
        -- customize the drawing of kind icons
        kind_icon = {
            text = function(ctx)
                -- default kind icon
                local icon = ctx.kind_icon
                -- if LSP source, check for color derived from documentation
                if ctx.item.source_name == 'LSP' then
                    local color_item = require('nvim-highlight-colors').format(
                        ctx.item.documentation,
                        { kind = ctx.kind }
                    )
                    if color_item and color_item.abbr ~= '' then
                        icon = color_item.abbr
                    end
                end
                return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
                -- default highlight group
                local highlight = 'BlinkCmpKind' .. ctx.kind
                -- if LSP source, check for color derived from documentation
                if ctx.item.source_name == 'LSP' then
                    local color_item = require('nvim-highlight-colors').format(
                        ctx.item.documentation,
                        { kind = ctx.kind }
                    )
                    if color_item and color_item.abbr_hl_group then
                        highlight = color_item.abbr_hl_group
                    end
                end
                return highlight
            end,
        },
    },
}

local opts = {
    keymap = keymaps,

    appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
    },

    completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        menu = {
            draw = draw_highlight_colors,
        },
    },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
        providers = {
            lazydev = {
                module = 'lazydev.integrations.blink',
                score_offset = 100,
            },
        },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See :h blink-cmp-config-fuzzy for more information
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
}

return { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
        -- Snippet Engine
        {
            'L3MON4D3/LuaSnip',
            version = '2.*',
            build = (function()
                -- Build Step is needed for regex support in snippets.
                -- This step is not supported in many windows environments.
                -- Remove the below condition to re-enable on windows.
                if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                    return
                end
                return 'make install_jsregexp'
            end)(),
            opts = {},
        },
        {
            'rafamadriz/friendly-snippets',
            config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
            end,
        },
        'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @diagnostic disable-next-line: undefined-doc-name
    --- @type blink.cmp.Config
    opts = opts,
}
