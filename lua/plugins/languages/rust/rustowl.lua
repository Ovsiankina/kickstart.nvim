---@diagnostic disable-next-line: unused-local
local keymaps = function(client, buffer)
    vim.keymap.set('n', '<leader>to', function()
        local rustowl = require 'rustowl'
        rustowl.toggle(buffer)
        vim.notify(
            'RustOwl ' .. (rustowl.is_enabled() and 'enabled' or 'disabled'),
            vim.log.levels.INFO
        )
    end, { buffer = buffer, desc = 'Toggle Rust[o]wl highlight' })

    vim.keymap.set('n', '<leader>oh', function()
        require('lib.rustowl_hint').show()
    end, { buffer = buffer, desc = 'RustOwl: explain c[o]lor / [h]int' })
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'rust',
    callback = function(ev)
        keymaps(nil, ev.buf)
    end,
})

return {
    'cordx56/rustowl',
    version = '*',
    -- build = 'cargo binstall rustowl',
    ft = 'rust',
    enabled = true,
    opts = {
        auto_enable = true,
    },
}
