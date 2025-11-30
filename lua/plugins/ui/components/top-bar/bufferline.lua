local keymaps = {
    {
        '<leader>Bp',
        '<Cmd>BufferLineTogglePin<CR>',
        mode = 'n',
        desc = 'Toggle [p]in',
    },
    {
        '<leader>Bd',
        '<Cmd>BufferLineGroupClose ungrouped<CR>',
        mode = 'n',
        desc = '[d]elete Non-Pinned Buffers',
    },
    {
        '<leader>Bx',
        '<Cmd>BufferLineCloseOthers<CR>',
        mode = 'n',
        desc = 'Delete [x] Other Buffers',
    },
    {
        'H',
        '<cmd>BufferLineCyclePrev<cr>',
        mode = 'n',
        desc = 'Prev Buffer',
    },
    {
        'L',
        '<cmd>BufferLineCycleNext<cr>',
        mode = 'n',
        desc = 'Next Buffer',
    },
}

local function generate_underline_highlights()
    local function underline_color()
        local highlight = vim.api.nvim_get_hl(0, { name = 'Error' }).fg
        local fallback = '#ff0000' -- red

        -- Use the foreground color, fallback to 'red' if not set
        return highlight and string.format('#%06x', highlight) or fallback
    end

    local groups = {
        'numbers_selected',
        'buffer_selected',
        'modified_selected',
        'indicator_selected',
        'tab_selected',
        'close_button_selected',
        'tab_separator_selected',
        'duplicate_selected',
        'separator_selected',
        'pick_selected',
        'diagnostic_selected',
        'error_selected',
        'error_diagnostic_selected',
        'info_selected',
        'info_diagnostic_selected',
        'warning_selected',
        'warning_diagnostic_selected',
        'hint_selected',
        'hint_diagnostic_selected',
    }
    local highlights = {}
    for _, group in ipairs(groups) do
        highlights[group] = {
            sp = underline_color(),
            underline = true,
            bold = true,
        }
    end

    -- Add bold for buffer_selected as in your original config
    highlights.buffer_selected.bold = true

    return highlights
end

local function opts(bufferline)
    return {
        options = {
            mode = 'buffers', -- set to "tabs" to only show tabpages instead
            style_preset = bufferline.style_preset.default,

            themable = true,
            -- "none" | "ordinal" | "buffer_id" | "both" |
            -- function({ ordinal, id, lower, raise }): string,
            numbers = 'buffer_id',

            -- 'icon' | 'underline' | 'none',
            indicator = { style = 'underline' },

            -- true | "nvim_lsp" | "coc",
            diagnostics = 'nvim_lsp',
            color_icons = true,
            show_close_icon = false,

            -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
            separator_style = 'thin',
            always_show_bufferline = false,
            auto_toggle_bufferline = true,
            diagnostics_indicator = function(
                ---@diagnostic disable-next-line: unused-local
                count,
                ---@diagnostic disable-next-line: unused-local
                level,
                diagnostics_dict,
                ---@diagnostic disable-next-line: unused-local
                context
            )
                local s = ' '
                for e, n in pairs(diagnostics_dict) do
                    local sym = e == 'error' and ' '
                        or (e == 'warning' and ' ' or ' ')
                    s = s .. n .. sym
                end
                return s
            end,
        },

        highlights = generate_underline_highlights,
    }
end
return {
    'akinsho/bufferline.nvim',
    version = '*',
    lazy = false,
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        local bufferline = require 'bufferline'
        bufferline.setup(opts(bufferline))
    end,
    keys = keymaps,
}
