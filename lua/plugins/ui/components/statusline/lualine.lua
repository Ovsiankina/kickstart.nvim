local function style()
    -- Color table for highlights
    -- stylua: ignore
    -- Synced with the venommono theme (lua/themes/venommono.lua, palette in
    -- lua/lib/monochrome_base.lua): monochrome gray base + the single venom red
    -- accent. The ONLY exception is the neovim-mode colors below -- those stay
    -- hue-distinct so the mode is glanceable, but their saturation is pulled up
    -- to match the venom red (#fc302e ~ 97% S / 58% L) instead of the old
    -- washed-out pastels that fought the monochrome code.
    local colors = {
        -- venommono base
        bg       = '#0b0b0b', -- statusline_bg
        fg       = '#d4d4d4', -- gray9 (soft white text)
        accent   = '#fc302e', -- the one venom red
        gray5    = '#747474',
        gray6    = '#8b8b8b',
        gray7    = '#a3a3a3',
        gray8    = '#bbbbbb',

        -- neovim MODE colors (the deliberate exception -- kept vivid)
        red      = '#fc302e', -- = venom red
        green    = '#2cfc2c',
        yellow   = '#fceb2c',
        orange   = '#fc942c',
        violet   = '#942cfc',
        cyan     = '#2cfcfc',
        blue     = '#2c94fc',
    }

    local conditions = {
        buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand '%:t') ~= 1
        end,
        hide_in_width = function()
            return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
            local filepath = vim.fn.expand '%:p:h'
            local gitdir = vim.fn.finddir('.git', filepath .. ';')
            return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
    }

    -- Config
    local config = {
        options = {
            -- Disable sections and component separators
            component_separators = '',
            section_separators = '',
            theme = {
                -- We are going to use lualine_c an lualine_x as left and
                -- right section. Both are highlighted by c theme .  So we
                -- are just setting default looks o statusline
                normal = { c = { fg = colors.fg, bg = colors.bg } },
                inactive = { c = { fg = colors.fg, bg = colors.bg } },
            },
            -- true: One unique global lualine
            -- false: One lualine per windows
            globalstatus = false,
        },
        sections = {
            -- these are to remove the defaults
            lualine_a = {},
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            -- These will be filled later
            lualine_c = {},
            lualine_x = {},
        },
        inactive_sections = {
            -- these are to remove the defaults
            lualine_a = {},
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            lualine_c = {},
            lualine_x = {},
        },
    }

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x at right section
    local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
    end

    ins_left {
        function()
            return '▊'
        end,
        color = { fg = colors.accent }, -- Sets highlighting of component
        padding = { left = 0, right = 1 }, -- We don't need space before this
    }

    ins_left {
        function()
            -- auto change lualine icons according to neovims mode
            local mode_icon = {
                n = ' [n]',
                i = ' [i]',
                v = ' [v]',
                [''] = ' [^v]',
                V = ' [V]',
                c = ' [c]',
                no = ' [no]',
                s = ' [s]',
                S = ' [S]',
                [''] = ' [^S]',
                ic = ' [ic]', -- completion pending
                R = ' [R]',
                Rv = ' [Rv]',
                cv = ' [cv]',
                ce = ' [ce]',
                r = ' [r]',
                rm = ' [rm]',
                ['r?'] = ' [r?]',
                ['!'] = ' [!]',
                t = ' [t]',
            }
            return mode_icon[vim.fn.mode()]
        end,
        color = function()
            -- auto change color according to neovims mode
            local mode_color = {
                n = colors.green,
                i = colors.blue,
                v = colors.violet,
                [''] = colors.violet,
                V = colors.violet,
                c = colors.yellow,
                no = colors.red,
                s = colors.orange,
                S = colors.orange,
                [''] = colors.orange,
                ic = colors.yellow,
                R = colors.red,
                Rv = colors.red,
                cv = colors.red,
                ce = colors.red,
                r = colors.cyan,
                rm = colors.cyan,
                ['r?'] = colors.cyan,
                ['!'] = colors.red,
                t = colors.red,
            }
            return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { right = 1 },
    }

    ins_left {
        'branch',
        icon = '',
        -- color = { fg = colors.violet, gui = 'bold' },
    }

    ins_left {
        'diff',
        -- Is it me or the symbol for modified is really weird
        symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
        diff_color = {
            added = { fg = colors.gray7 },
            modified = { fg = colors.gray8 },
            removed = { fg = colors.accent },
        },
        cond = conditions.hide_in_width,
    }

    ins_left {
        require('noice').api.statusline.mode.get,
        cond = require('noice').api.statusline.mode.has,
        color = { fg = colors.orange },
    }

    ins_left {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
        diagnostics_color = {
            error = { fg = colors.red }, -- venom red (= accent)
            warn = { fg = colors.gray8 },
            info = { fg = colors.gray6 },
        },
    }

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    ins_left {
        function()
            return '%='
        end,
    }

    ins_left {
        'filetype',
        colored = true,
        icon_only = true,
    }

    ins_left {
        'filename',
        cond = conditions.buffer_not_empty,
        icons_enabled = true,
        -- color = { fg = colors.green, gui = 'bold' },
        path = 0, -- 1 = relative path
        symbols = {
            modified = '[+]', -- Text to show when the file is modified.
            readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]', -- Text to show for newly created file before first write
        },
    }

    ins_right {
        -- Lsp server name .
        function()
            local msg = 'No Active Lsp'
            local buf_ft =
                vim.api.nvim_get_option_value('filetype', { buf = 0 })
            local clients = vim.lsp.get_clients()
            if next(clients) == nil then
                return msg
            end
            for _, client in ipairs(clients) do
                ---@diagnostic disable-next-line: undefined-field
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                end
            end
            return msg
        end,
        icon = ' ',
        color = {
            fg = colors.fg --[[ gui = 'bold' ]],
        },
    }

    -- Add components to right sections
    -- ins_right {
    --     'o:encoding', -- option component same as &encoding in viml
    --     fmt = string.upper, -- I'm not sure why it's upper case either ;)
    --     cond = conditions.hide_in_width,
    --     color = { fg = colors.green, gui = 'bold' },
    -- }

    -- ins_right {
    --     'fileformat',
    --     fmt = string.upper,
    --     icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
    --     color = { fg = colors.green, gui = 'bold' },
    -- }

    ins_right {
        'location',
    }
    ins_right {
        'progress',
        color = {
            fg = colors.fg, --[[ gui = 'bold']]
        },
    }

    ins_right {
        -- filesize component
        'filesize',
        cond = conditions.buffer_not_empty,
    }

    ins_right {
        function()
            return '▊'
        end,
        color = { fg = colors.accent },
        padding = { left = 1 },
    }

    return config
end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    config = function()
        -- Modified eviline config for lualine
        -- Author: Ovsiankina
        -- Credit: glepnir, shadmansaleh
        local lualine = require 'lualine'

        -- Now don't forget to initialize lualine
        lualine.setup(style())
    end,
}
