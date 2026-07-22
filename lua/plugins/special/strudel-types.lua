-- Strudel type support for .str/.std files: real completion + hover, no false
-- "undefined global" diagnostics. Companion to strudel.nvim.
-- The vtsls root_dir pin that makes this work lives in ../ide/tooling.lua.
return {
    'Ovsiankina/strudel-types.nvim',
    -- Loaded from ~/Documents/nvim-plugins/strudel-types.nvim (see lazy `dev` in
    -- plugin-manager.lua). Falls back to the GitHub clone if that dir is absent.
    dev = true,
    dependencies = { 'gruvw/strudel.nvim' },
    -- Tiny: only registers a .str autocmd + user commands so the LSP root_dir
    -- helpers exist. Heavy work (loading the typedef, regenerating) is deferred.
    lazy = false,
    config = function()
        -- Always-on for .str/.std (loads lazily on first such buffer, no prompt).
        require('strudel-types').setup {
            -- `mf` sound picker: <Tab> previews the sound (spinner + bar).
            -- preview_progress_min_ms = 0, -- only show the bar for sounds >= N ms (0 = always)
        }
    end,
}
