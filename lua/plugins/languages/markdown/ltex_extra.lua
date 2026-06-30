-- File name: ltex_extra.lua
-- Author: ovsiankina
-- Date created: 2025-12-09 13:43:24
-- Date modified: 2026-06-23 09:30:00
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

-- ltex-ls emits OFF-SPEC, client-side commands for its code actions:
--   _ltex.addToDictionary / _ltex.hideFalsePositives / _ltex.disableRules
-- Neovim has no built-in handler, so `vim.lsp.buf.code_action` on an ltex
-- suggestion warns: "Language server ltex does not support command
-- `_ltex.hideFalsePositives`". ltex_extra.nvim supplies those handlers AND
-- persists the dictionary / false-positives / disabled-rules to disk.
--
-- We do NOT let ltex_extra start the server: ltex is already started by our
-- mason / vim.lsp.config setup (see plugins/ide/tooling.lua + mason.lua).
-- ltex_extra.setup() registers the `vim.lsp.commands` handlers BEFORE it ever
-- touches `require('lspconfig')` (that require lives only in its server-start
-- path), so with `server_start = false` we get the handlers + persistence
-- without the deprecated lspconfig codepath.
-- Refs: https://github.com/barreiroleo/ltex_extra.nvim
--       https://github.com/neovim/nvim-lspconfig/issues/3494

local langs = { 'fr', 'en-US' }
local data_path = vim.fn.stdpath 'config' .. '/spell/ltex'

return {
    'barreiroleo/ltex_extra.nvim',
    ft = { 'markdown', 'tex' },
    config = function()
        -- ltex_extra's fs.mkdir uses uv.fs_mkdir, which is NON-recursive. If any
        -- parent (spell/, or ltex/) is missing it returns false, then check_dir
        -- indexes a nil stat -> "attempt to index local 'stat' (a nil value)".
        -- Pre-create the full path ourselves so exportFile always succeeds.
        vim.fn.mkdir(data_path, 'p')

        require('ltex_extra').setup {
            load_langs = langs,
            -- MUST stay false. With server_start = false, setup() calls
            -- first_load() immediately (init.lua else-branch). init_check = true
            -- would make it reload() BEFORE ltex attaches -> catch_ltex() finds
            -- no client -> error "Error catching ltex client" (commands-lsp.lua).
            -- We reload only on real attach, via the LspAttach autocmd below.
            init_check = false,
            -- Personal dictionary / hidden-false-positives / disabled-rules
            -- live here. They are stable across projects and worth versioning.
            path = data_path,
            -- Server is owned by mason/vim.lsp.config, not by ltex_extra.
            -- This skips call_ltex() (the only place that requires lspconfig).
            server_start = false,
        }

        -- Because ltex_extra is not the one attaching the server, its own
        -- on_attach -> first_load() never fires. Push the stored dictionaries
        -- to the ltex client ourselves whenever it attaches.
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup(
                'ltex-extra-reload',
                { clear = true }
            ),
            callback = function(args)
                local client =
                    vim.lsp.get_client_by_id(args.data.client_id)
                if
                    client
                    and (client.name == 'ltex' or client.name == 'ltex_plus')
                then
                    require('ltex_extra').reload(langs)
                end
            end,
        })

        -- Handle the case where ltex attached BEFORE this config ran (the
        -- LspAttach above would have already missed): reload for any live
        -- ltex client right now.
        for _, client in ipairs(vim.lsp.get_clients { name = 'ltex' }) do
            if client then
                require('ltex_extra').reload(langs)
            end
        end
    end,
}
