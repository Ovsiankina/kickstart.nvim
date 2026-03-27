-- File name: render-markdown.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 19:11:13
-- Date modified: 2025-12-01 19:13:10
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local function keymaps()
    vim.keymap.set('n', '<leader>mv', function()
        local image = require 'image'
        local is_enabled = image.is_enabled()

        -- Toggle RenderMarkdown
        vim.cmd 'RenderMarkdown toggle'

        -- If it was disabled and now is enabled, enable image
        -- We delay checking with a timer to wait for RenderMarkdown to activate
        vim.defer_fn(function()
            -- Simple re-check: assume toggling flips the state
            if not is_enabled then
                image.enable()
            else
                image.disable()
            end
        end, 100) -- Wait 100ms (adjustable delay)
    end, { desc = 'Render [m]arkdown [v]iew and sync image.nvim' })

    vim.keymap.set('n', '<leader>mf', function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo[buf].filetype
        if ft ~= 'markdown' then
            return
        end

        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local new_lines = {}

        for _, line in ipairs(lines) do
            if #line <= 80 then
                table.insert(new_lines, line)
            else
                local indent = line:match '^(%s*)'
                local remaining = line

                while #remaining > 80 do
                    local cut = remaining:sub(1, 80):match '.*()%s'
                    if not cut or cut <= #indent + 1 then
                        break
                    end
                    table.insert(new_lines, remaining:sub(1, cut - 1))
                    remaining = indent .. remaining:sub(cut + 1)
                end

                table.insert(new_lines, remaining)
            end
        end

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
    end, { desc = '[M]arkdown [F]ix line length' })
end

keymaps()

return {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },

    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@type render.md.UserConfig
    opts = {
        completions = { blink = { enabled = true } },
    },
}
