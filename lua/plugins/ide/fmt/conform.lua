-- NOTE: configuration: DONE (27.11.25)
local tools = require 'plugins.ide.tooling'
local formatters = tools.mason_packages.formatters

-- local keymaps = {
--     {
--         -- NOTE: Keymap not needed since I prefer auto-formating the file with 'BufWritePre' (on save).
--         '<leader>fb',
--         function()
--             require('conform').format {
--                 async = true,
--                 lsp_format = 'fallback',
--             }
--         end,
--         mode = '',
--         desc = '[F]ormat [b]uffer',
--     },
-- }

return { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    -- keys = keymaps,
    opts = {
        notify_on_error = true,
        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return {
                    timeout_ms = 500,
                    lsp_format = 'fallback',
                }
            end
        end,
        formatters_by_ft = formatters,
    },
}
