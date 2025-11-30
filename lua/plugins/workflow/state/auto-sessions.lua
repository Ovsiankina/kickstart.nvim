local keymaps = {
    keys = {
        {
            '<leader>fa',
            '<cmd>AutoSession search<CR>',
            desc = '[F]ind [A]uto-session',
        },
        {
            '<leader>As',
            '<cmd>SessionSave<CR>',
            desc = '[A]uto-session [s]ave',
        },
    },
    mappings = {
        -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
        delete_session = { 'i', '<C-d>' }, -- mode and key for deleting a session from the picker
        alternate_session = { 'i', '<C-s>' }, -- mode and key for swapping to alternate session from the picker
        copy_session = { 'i', '<C-y>' }, -- mode and key for copying a session from the picker
    },
}

return {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@type AutoSession.Config

    keys = keymaps.keys,
    opts = {
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        -- log_level = 'debug',
        -- Sessions older than purge_after_minutes will be deleted asynchronously on startup, e.g. 14400 (10 days)
        purge_after_minutes = 20160, -- 14 days
        sessions_lens = {
            mappings = keymaps.mappings,
        },
    },
}
