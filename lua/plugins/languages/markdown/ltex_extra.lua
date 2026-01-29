-- File name: ltex_extra.lua
-- Author: ovsiankina
-- Date created: 2025-12-09 13:43:24
-- Date modified: 2025-12-09 13:59:00
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

-- New plugin block (example: add alongside other plugin specs)

-- TODO: Re-enable when ltex_extra.nvim migrates to vim.lsp.config
-- Tracking: https://github.com/barreiroleo/ltex_extra.nvim (check dev branch)
-- Related: https://github.com/neovim/nvim-lspconfig/issues/3494
return {
    'barreiroleo/ltex_extra.nvim',
    enabled = false, -- Disabled: uses deprecated require('lspconfig')
    ft = { 'markdown', 'tex' },
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
        local capabilities = require('blink.cmp').get_lsp_capabilities()
        require('ltex_extra').setup {
            load_langs = { 'fr', 'en-US' },
            server_opts = {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    -- your on_attach process
                end,
                settings = {
                    ltex = {
                        language = 'auto',
                        diagnosticSeverity = 'information',
                        sentenceCacheSize = 2000,
                        additionalRules = {
                            enablePickyRules = true,
                            motherTongue = 'fr',
                        },
                    },
                },
            },
        }
    end,
}
