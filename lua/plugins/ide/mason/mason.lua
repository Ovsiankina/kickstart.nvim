-- NOTE: configuration: DONE (27.11.25)

local function package_table(packages)
    local ensure_installed = {}
    for _, server_tbl in pairs(packages) do
        if type(server_tbl) == 'table' then
            vim.list_extend(ensure_installed, vim.tbl_keys(server_tbl))
        end
    end
    return ensure_installed
end

local function register_lsp_server_config(lsp_packages)
    -- Capabilities advertised to servers
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    for name, conf in pairs(lsp_packages or {}) do
        local cfg = vim.tbl_deep_extend(
            'force',
            { capabilities = capabilities },
            conf or {}
        )
        -- WARN: do not start clients here; just register the config
        vim.lsp.config(name, cfg)
    end
end

return {
    'mason-org/mason.nvim',
    dependencies = {

        'mason-org/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'jay-babu/mason-nvim-dap.nvim',
        'saghen/blink.cmp',
    },
    -- opts = {},
    config = function()
        local tools = require 'plugins.ide.tooling'
        local packages = tools.mason_packages -- { lsp = { name = { .. }, ... }, formatters=..., dap=... }
        local excluded = tools.excluded_packages -- servers managed by other plugins (e.g. rustaceanvim)

        local ensure_installed = package_table(packages)
        ---------------------------------------------------------------------------
        -- Ensure tools via mason-tool-installer
        ---------------------------------------------------------------------------
        require('mason-tool-installer').setup {
            ensure_installed = ensure_installed,
        }

        ---------------------------------------------------------------------------
        -- Mason core
        ---------------------------------------------------------------------------
        require('mason').setup()

        ---------------------------------------------------------------------------
        -- Neovim 0.11+ LSP setup: register configs via vim.lsp.config()
        -- mason-lspconfig will auto-enable servers (except those in excluded)
        ---------------------------------------------------------------------------

        register_lsp_server_config(packages.lsp)

        require('mason-lspconfig').setup {
            ensure_installed = {},
            automatic_enable = {
                exclude = excluded,
            },
        }
    end,
}
