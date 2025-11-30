-- File name: header.lua
-- Author: ovsiankina
-- Date created: 2025-11-30 15:03:19
-- Date modified: 2025-11-30 15:29:52
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local function keymaps(header)
    vim.keymap.set('n', '<leader>ch', function()
        header.add_headers()
    end)
end

return {
    'attilarepka/header.nvim',
    config = function()
        local header = require 'header'
        header.setup {
            allow_autocmds = true,
            file_name = true,
            author = 'Ovsiankina',
            -- project = 'header.nvim',
            date_created = true,
            date_created_fmt = '%Y-%m-%d %H:%M:%S',
            date_modified = true,
            date_modified_fmt = '%Y-%m-%d %H:%M:%S',
            line_separator = '----------------------------------',
            use_block_header = false,
            copyright_text = {
                'Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>',
                '',
                'All rights reserved.',
            },
            license_from_file = false,
            author_from_git = true,
        }

        keymaps(header)
    end,
}
