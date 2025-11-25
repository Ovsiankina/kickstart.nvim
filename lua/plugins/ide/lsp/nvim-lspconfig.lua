-- TODO: conditional inclusion of tools depending of 'settings.enabled-languages'
-- Your server/tool definitions
local tools = require 'lua.plugins.ide.tooling'
local packages = tools.mason_packages -- { lsp = { name = { .. }, ... }, formatters=..., dap=... }
local excluded = tools.excluded_packages -- servers managed by other plugins (e.g. rustaceanvim)

return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'mason-org/mason.nvim', opts = {} },
        'mason-org/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'j-hui/fidget.nvim', opts = {} },
        'saghen/blink.cmp',
    },
    config = function()
        ---------------------------------------------------------------------------
        -- LSP attach events, diagnostics, etc. (unchanged from your version)
        ---------------------------------------------------------------------------
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup(
                'kickstart-lsp-attach',
                { clear = true }
            ),
            callback = function(event)
                -- Keymaps.lsp.keys(event)

                --- Resolve supports_method API difference between 0.11 and 0.10
                ---@param client vim.lsp.Client
                ---@param method vim.lsp.protocol.Method
                ---@param bufnr? integer
                local function client_supports_method(client, method, bufnr)
                    if vim.fn.has 'nvim-0.11' == 1 then
                        return client:supports_method(method, bufnr)
                    else
                        return client.supports_method(method, { bufnr = bufnr })
                    end
                end

                local client = vim.lsp.get_client_by_id(event.data.client_id)

                -- Highlight references on CursorHold if supported
                if
                    client
                    and client_supports_method(
                        client,
                        vim.lsp.protocol.Methods.textDocument_documentHighlight,
                        event.buf
                    )
                then
                    local highlight_augroup = vim.api.nvim_create_augroup(
                        'kickstart-lsp-highlight',
                        { clear = false }
                    )
                    vim.api.nvim_create_autocmd(
                        { 'CursorHold', 'CursorHoldI' },
                        {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        }
                    )
                    vim.api.nvim_create_autocmd(
                        { 'CursorMoved', 'CursorMovedI' },
                        {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        }
                    )
                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup(
                            'kickstart-lsp-detach',
                            { clear = true }
                        ),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds {
                                group = 'kickstart-lsp-highlight',
                                buffer = event2.buf,
                            }
                        end,
                    })
                end

                -- Optional inlay hints toggle if supported
                -- if
                --     client
                --     and client_supports_method(
                --         client,
                --         vim.lsp.protocol.Methods.textDocument_inlayHint,
                --         event.buf
                --     )
                -- then
                --     Keymaps.lsp.conditional_keys(event)
                -- end
            end,
        })

        vim.diagnostic.config {
            severity_sort = true,
            float = { border = 'rounded', source = 'if_many' },
            underline = true,
            signs = vim.g.have_nerd_font
                    and {
                        text = {
                            [vim.diagnostic.severity.ERROR] = '󰅚 ',
                            [vim.diagnostic.severity.WARN] = '󰀪 ',
                            [vim.diagnostic.severity.INFO] = '󰋽 ',
                            [vim.diagnostic.severity.HINT] = '󰌶 ',
                        },
                    }
                or {},
            virtual_text = {
                source = 'if_many',
                spacing = 2,
                format = function(diagnostic)
                    return diagnostic.message
                end,
            },
        }

        -- Capabilities advertised to servers (blink.cmp)
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        ---------------------------------------------------------------------------
        -- Ensure tools via mason-tool-installer (your existing logic)
        ---------------------------------------------------------------------------
        local ensure_installed = {}
        for _, server_tbl in pairs(packages) do
            if type(server_tbl) == 'table' then
                vim.list_extend(ensure_installed, vim.tbl_keys(server_tbl))
            end
        end
        require('mason-tool-installer').setup {
            ensure_installed = ensure_installed,
        }

        ---------------------------------------------------------------------------
        -- Mason core
        ---------------------------------------------------------------------------
        require('mason').setup()

        ---------------------------------------------------------------------------
        -- v2 flow (Neovim 0.11+): define configs up-front via vim.lsp.config()
        -- fallback for 0.10: use lspconfig.setup()
        ---------------------------------------------------------------------------
        -- Register server configs (merge your per-server table over default {capabilities})
        for name, conf in pairs(packages.lsp or {}) do
            local cfg = vim.tbl_deep_extend(
                'force',
                { capabilities = capabilities },
                conf or {}
            )
            -- IMPORTANT: do not start clients here; just register the config
            vim.lsp.config(name, cfg)
        end

        -- Mason-LSPConfig v2: no handlers, no automatic_installation
        require('mason-lspconfig').setup {
            ensure_installed = {}, -- you install via mason-tool-installer
            automatic_enable = {
                exclude = excluded,
            },
        }
        -- mason-lspconfig v1 style (safe no-op on v2)
        pcall(function()
            require('mason-lspconfig').setup {
                ensure_installed = {},
                automatic_installation = false, -- ignored on v2, valid on v1
            }
        end)
    end,
}
