return {
    'mrcjkb/rustaceanvim',
    dependencies = {
        'mfussenegger/nvim-dap',
        -- DAP server: codelldb OR lldb-dap
    },

    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
    config = function()
        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
                on_attach = function(client, bufnr)
                    -- you can also put keymaps in here
                end,
                default_settings = {
                    -- rust-analyzer language server configuration
                    ['rust-analyzer'] = {},
                },
            },
            -- DAP configuration
            dap = {},
        }
    end,
}

-- How to dynamically load different rust-analyzer settings per project
--
-- By default, this plugin will look for a .vscode/settings.json2 file and attempt to load it. If the file does not exist, or it can't be decoded, the server.default_settings will be used.
