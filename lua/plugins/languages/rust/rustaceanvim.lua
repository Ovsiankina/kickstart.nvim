return {
    'mrcjkb/rustaceanvim',
    dependencies = {
        'mfussenegger/nvim-dap',
        -- DAP server: codelldb OR lldb-dap
    },

    version = '^8', -- pin to a major; v7+ replaced the deprecated vim.lsp.get_buffers_by_client_id() call
    lazy = false, -- This plugin is already lazy
    config = function()
        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
                -- Don't auto-attach when disabled for this session.
                auto_attach = function(bufnr)
                    return not vim.g.rust_analyzer_disabled
                end,
                on_attach = function(client, bufnr)
                    -- you can also put keymaps in here
                end,
                default_settings = {
                    -- rust-analyzer language server configuration
                    ['rust-analyzer'] = {
                        -- Separate target dir so RA's cargo check never fights
                        -- your terminal `cargo` over the same fingerprints.
                        cargo = {
                            targetDir = true, -- -> target/rust-analyzer
                        },
                        -- Check only what's needed, not --all-targets/all-features.
                        check = {
                            command = 'clippy',
                            allTargets = false,
                            workspace = true,
                        },
                        -- Don't pre-build the whole workspace on startup.
                        cachePriming = {
                            enable = false,
                        },
                        -- Skip rebuilding proc-macro/build scripts churn on nav.
                        procMacro = {
                            enable = true,
                        },
                    },
                },
            },
            -- DAP configuration
            dap = {},
        }

        -- Disable rust-analyzer for the rest of this nvim session.
        -- Sets the gate flag, then stops any running clients so they
        -- don't get re-attached on the next rust buffer.
        vim.api.nvim_create_user_command('RustAnalyzerDisable', function()
            vim.g.rust_analyzer_disabled = true
            for _, client in ipairs(vim.lsp.get_clients { name = 'rust-analyzer' }) do
                client:stop(true)
            end
        end, { desc = 'Disable rust-analyzer for this session' })

        vim.api.nvim_create_user_command('RustAnalyzerEnable', function()
            vim.g.rust_analyzer_disabled = false
            vim.cmd.edit() -- re-trigger filetype/attach on current buffer
        end, { desc = 'Re-enable rust-analyzer for this session' })
    end,
}

-- How to dynamically load different rust-analyzer settings per project
--
-- By default, this plugin will look for a .vscode/settings.json2 file and attempt to load it. If the file does not exist, or it can't be decoded, the server.default_settings will be used.
