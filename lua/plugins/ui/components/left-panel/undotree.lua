-- File name: undotree.lua
-- Author: ovsiankina
-- Date created: 2025-12-01 19:28:17
-- Date modified: 2025-12-01 19:29:27
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local function keymaps()
    vim.keymap.set(
        'n',
        '<leader>tu',
        vim.cmd.UndotreeToggle,
        { desc = 'Toggle [u]ndotree' }
    )

    -- If Undotree not toggled (open), toggle it; otherwise, just focus it
    vim.keymap.set('n', '<leader>u', function()
        local undotree_open = false

        -- Loop through windows to check if undotree buffer is visible
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local buf_name = vim.api.nvim_buf_get_name(buf)

            -- Check if buffer name contains 'undotree' which is usually the case
            if buf_name:match 'undotree_' then
                undotree_open = true
                break
            end
        end

        if undotree_open then
            vim.cmd.UndotreeFocus()
        else
            vim.cmd.UndotreeToggle()
        end
    end, { desc = 'Focus or Toggle [u]ndotree' })
end

keymaps()

return {
    'mbbill/undotree',
    lazy = false,
}
