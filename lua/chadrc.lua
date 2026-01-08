-- File name: chadrc.lua
-- Author: ovsiankina
-- Date created: 2025-11-30 17:25:05
-- Date modified: 2025-12-04 08:52:54
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local options = {

    base46 = {
        enabled = true,
        theme = 'tokyodark', -- default theme
        hl_add = {
            LineNrBelow = {
                fg = '#a9b1d6', -- orange (hex code)
            },
            LineNrAbove = {
                fg = '#a9b1d6', -- orange (hex code)
            },
            -- ['@lsp.type.property'] = { fg = '#28b5ce' },
            -- ['@lsp.type.method'] = { fg = '#79A1F5' },
            -- ['@lsp.type.namespace'] = { fg = '#79A1F5' },
        },
        hl_override = {
            LineNr = {
                fg = '#FFA500', -- orange (hex code)
            },
            CursorLineNr = {
                fg = '#FFA500', -- same or brighter orange
                bold = true,
            },
            ['@constructor'] = { fg = '#79A1F5' },
        },
        integrations = {},
        changed_themes = {},
        -- BUG: transparency set to true fucks with base46 telescope theming
        -- NOTE: terminal is already transparent. It'll just remove bg color
        transparency = false,
        theme_toggle = { 'tokyonight', 'tokyodark' },
    },
    { import = 'nvchad.blink.lazyspec' },
    ui = {
        cmp = {
            enabled = true,
            icons_left = false, -- only for non-atom styles!

            -- default/flat_light/flat_dark/atom/atom_colored
            style = 'atom_colored',
            abbr_maxwidth = 60,
            -- for tailwind, css lsp etc
            format_colors = { lsp = true, icon = '󱓻' },
        },

        telescope = { style = 'borderless' }, -- borderless / bordered

        statusline = {
            enabled = false,
            theme = 'default', -- default/vscode/vscode_colored/minimal
            -- default/round/block/arrow separators work only for default statusline theme
            -- round and block will work for minimal theme only
            separator_style = 'default',
            order = nil,
            modules = nil,
        },

        -- lazyload it when there are 1+ buffers
        tabufline = {
            enabled = false,
            lazyload = true,
            order = { 'treeOffset', 'buffers', 'tabs', 'btns' },
            modules = nil,
            bufwidth = 21,
        },
    },

    nvdash = {
        enabled = false,
    },

    term = {
        base46_colors = true,
        winopts = { number = false, relativenumber = false },
        sizes = { sp = 0.3, vsp = 0.2, ['bo sp'] = 0.3, ['bo vsp'] = 0.2 },
        float = {
            relative = 'editor',
            row = 0.3,
            col = 0.25,
            width = 0.5,
            height = 0.4,
            border = 'single',
        },
    },

    lsp = { signature = false },

    cheatsheet = {
        theme = 'grid', -- simple/grid
        -- excluded_groups = { 'terminal (t)', 'autopairs', 'Nvim', 'Opens' }, -- can add group name or with mode
    },

    -- mason = { pkgs = {}, skip = {} },

    colorify = {
        enabled = true,
        mode = 'virtual', -- fg, bg, virtual
        virt_text = '󱓻 ',
        highlight = { hex = true, lspvars = true },
    },
}

local status, chadrc = pcall(require, 'chadrc')
return vim.tbl_deep_extend('force', options, status and chadrc or {})
