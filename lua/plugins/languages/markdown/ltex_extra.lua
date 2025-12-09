-- File name: ltex_extra.lua
-- Author: ovsiankina
-- Date created: 2025-12-09 13:43:24
-- Date modified: 2025-12-09 13:59:00
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

-- New plugin block (example: add alongside other plugin specs)

return {
    'barreiroleo/ltex_extra.nvim',
    ft = { 'markdown', 'tex' },
    dependencies = { 'neovim/nvim-lspconfig' },
    -- yes, you can use the opts field, just I'm showing the setup explicitly
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
