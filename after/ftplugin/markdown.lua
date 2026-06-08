-- File name: markdown.lua
-- Author: ovsiankina
-- ----------------------------------
-- Buffer-local keymaps for markdown buffers.
--
-- These maps used to be registered globally (in the render-markdown.lua and
-- markdown-preview.lua plugin specs), which leaked them onto every buffer
-- (e.g. Strudel .str files). They are scoped here to markdown buffers only.

-- <leader>mv : Toggle RenderMarkdown and keep image.nvim in sync.
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
end, { buffer = true, desc = 'Render [m]arkdown [v]iew and sync image.nvim' })

-- <leader>mf : Fix line length (hard-wrap at 80 columns).
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
end, { buffer = true, desc = '[M]arkdown [F]ix line length' })

-- <leader>mp : Toggle markdown-preview.nvim in the browser.
vim.keymap.set(
    'n',
    '<leader>mp',
    '<cmd>MarkdownPreviewToggle<CR>',
    { buffer = true, desc = 'Markdown [p]review' }
)
