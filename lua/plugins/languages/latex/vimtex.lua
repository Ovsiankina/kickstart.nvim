-- File name: vimtex.lua
-- Author: ovsiankina
-- ----------------------------------
-- VimTeX: A modern Vim/Neovim filetype plugin for LaTeX
-- NOTE: <localleader> defaults to '\'. Set maplocalleader before loading if needed.

local keymaps = function()
    local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = 'VimTeX: ' .. desc })
    end

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ COMPILATION & BUILDING                                                  │
    -- └─────────────────────────────────────────────────────────────────────────┘
    map('n', '<localleader>ll', '<plug>(vimtex-compile)', '[L]atex compi[L]e (toggle)')
    map('x', '<localleader>lL', '<plug>(vimtex-compile-selected)', '[L]atex compile se[L]ected')
    map('n', '<localleader>lk', '<plug>(vimtex-stop)', '[L]atex [K]ill compilation')
    map('n', '<localleader>lK', '<plug>(vimtex-stop-all)', '[L]atex [K]ill all')
    map('n', '<localleader>le', '<plug>(vimtex-errors)', '[L]atex [E]rrors')
    map('n', '<localleader>lo', '<plug>(vimtex-compile-output)', '[L]atex [O]utput')
    map('n', '<localleader>lc', '<plug>(vimtex-clean)', '[L]atex [C]lean aux')
    map('n', '<localleader>lC', '<plug>(vimtex-clean-full)', '[L]atex [C]lean all')
    map('n', '<localleader>lg', '<plug>(vimtex-status)', '[L]atex status (count words)')
    map('n', '<localleader>lG', '<plug>(vimtex-status-all)', '[L]atex status all')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ VIEW & NAVIGATION                                                       │
    -- └─────────────────────────────────────────────────────────────────────────┘
    map('n', '<localleader>lv', '<plug>(vimtex-view)', '[L]atex [V]iew PDF')
    map('n', '<localleader>lr', '<plug>(vimtex-reverse-search)', '[L]atex [R]everse search')
    map('n', '<localleader>lt', '<plug>(vimtex-toc-open)', '[L]atex [T]OC open')
    map('n', '<localleader>lT', '<plug>(vimtex-toc-toggle)', '[L]atex [T]OC toggle')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ INFO & STATUS                                                           │
    -- └─────────────────────────────────────────────────────────────────────────┘
    map('n', '<localleader>li', '<plug>(vimtex-info)', '[L]atex [I]nfo')
    map('n', '<localleader>lI', '<plug>(vimtex-info-full)', '[L]atex [I]nfo full')
    map('n', '<localleader>lq', '<plug>(vimtex-log)', '[L]atex log ([Q]uickfix)')
    map('n', '<localleader>lm', '<plug>(vimtex-imaps-list)', '[L]atex insert [M]appings')
    map('n', '<localleader>la', '<plug>(vimtex-context-menu)', '[L]atex context [A]ction')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ RELOAD                                                                  │
    -- └─────────────────────────────────────────────────────────────────────────┘
    map('n', '<localleader>lx', '<plug>(vimtex-reload)', '[L]atex reload')
    map('n', '<localleader>lX', '<plug>(vimtex-reload-state)', '[L]atex reload state')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ SECTION NAVIGATION                                                      │
    -- └─────────────────────────────────────────────────────────────────────────┘
    local nav_modes = { 'n', 'x', 'o' }
    map(nav_modes, '[[', '<plug>(vimtex-[[)', 'Prev section start')
    map(nav_modes, '[]', '<plug>(vimtex-[])', 'Prev section end')
    map(nav_modes, '][', '<plug>(vimtex-][)', 'Next section start')
    map(nav_modes, ']]', '<plug>(vimtex-]])', 'Next section end')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ ENVIRONMENT NAVIGATION                                                  │
    -- └─────────────────────────────────────────────────────────────────────────┘
    map(nav_modes, '[m', '<plug>(vimtex-[m)', 'Prev \\begin')
    map(nav_modes, '[M', '<plug>(vimtex-[M)', 'Prev \\end')
    map(nav_modes, ']m', '<plug>(vimtex-]m)', 'Next \\begin')
    map(nav_modes, ']M', '<plug>(vimtex-]M)', 'Next \\end')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ MATH NAVIGATION                                                         │
    -- └─────────────────────────────────────────────────────────────────────────┘
    map(nav_modes, '[n', '<plug>(vimtex-[n)', 'Prev math start')
    map(nav_modes, '[N', '<plug>(vimtex-[N)', 'Prev math end')
    map(nav_modes, ']n', '<plug>(vimtex-]n)', 'Next math start')
    map(nav_modes, ']N', '<plug>(vimtex-]N)', 'Next math end')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ FRAME NAVIGATION (beamer)                                               │
    -- └─────────────────────────────────────────────────────────────────────────┘
    map(nav_modes, '[r', '<plug>(vimtex-[r)', 'Prev frame start')
    map(nav_modes, '[R', '<plug>(vimtex-[R)', 'Prev frame end')
    map(nav_modes, ']r', '<plug>(vimtex-]r)', 'Next frame start')
    map(nav_modes, ']R', '<plug>(vimtex-]R)', 'Next frame end')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ COMMENT & DELIMITER NAVIGATION                                          │
    -- └─────────────────────────────────────────────────────────────────────────┘
    map(nav_modes, '[*', '<plug>(vimtex-[*)', 'Prev comment')
    map(nav_modes, ']*', '<plug>(vimtex-]*)', 'Next comment')
    map(nav_modes, '%', '<plug>(vimtex-%)', 'Matching delimiter')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ TEXT OBJECTS                                                            │
    -- └─────────────────────────────────────────────────────────────────────────┘
    local obj_modes = { 'x', 'o' }
    -- Commands
    map(obj_modes, 'ic', '<plug>(vimtex-ic)', 'Inner command')
    map(obj_modes, 'ac', '<plug>(vimtex-ac)', 'Around command')
    -- Delimiters
    map(obj_modes, 'id', '<plug>(vimtex-id)', 'Inner delimiter')
    map(obj_modes, 'ad', '<plug>(vimtex-ad)', 'Around delimiter')
    -- Environments
    map(obj_modes, 'ie', '<plug>(vimtex-ie)', 'Inner environment')
    map(obj_modes, 'ae', '<plug>(vimtex-ae)', 'Around environment')
    -- Math
    map(obj_modes, 'i$', '<plug>(vimtex-i$)', 'Inner math')
    map(obj_modes, 'a$', '<plug>(vimtex-a$)', 'Around math')
    -- Sections
    map(obj_modes, 'iP', '<plug>(vimtex-iP)', 'Inner section')
    map(obj_modes, 'aP', '<plug>(vimtex-aP)', 'Around section')
    -- Items
    map(obj_modes, 'im', '<plug>(vimtex-im)', 'Inner item')
    map(obj_modes, 'am', '<plug>(vimtex-am)', 'Around item')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ DELETE SURROUNDING                                                      │
    -- └─────────────────────────────────────────────────────────────────────────┘
    map('n', 'dsc', '<plug>(vimtex-delim-delete)', '[D]elete [S]urround [C]ommand')
    map('n', 'dse', '<plug>(vimtex-env-delete)', '[D]elete [S]urround [E]nvironment')
    map('n', 'ds$', '<plug>(vimtex-env-delete-math)', '[D]elete [S]urround math')
    map('n', 'dsd', '<plug>(vimtex-delim-delete)', '[D]elete [S]urround [D]elimiter')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ CHANGE SURROUNDING                                                      │
    -- └─────────────────────────────────────────────────────────────────────────┘
    map('n', 'csc', '<plug>(vimtex-cmd-change)', '[C]hange [S]urround [C]ommand')
    map('n', 'cse', '<plug>(vimtex-env-change)', '[C]hange [S]urround [E]nvironment')
    map('n', 'cs$', '<plug>(vimtex-env-change-math)', '[C]hange [S]urround math')
    map('n', 'csd', '<plug>(vimtex-delim-change-math)', '[C]hange [S]urround [D]elimiter')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ TOGGLE COMMANDS                                                         │
    -- └─────────────────────────────────────────────────────────────────────────┘
    map('n', 'tsc', '<plug>(vimtex-cmd-toggle-star)', '[T]oggle [S]tarred [C]ommand')
    map('n', 'tse', '<plug>(vimtex-env-toggle-star)', '[T]oggle [S]tarred [E]nvironment')
    map('n', 'ts$', '<plug>(vimtex-env-toggle-math)', '[T]oggle math inline/display')
    map('n', 'tsd', '<plug>(vimtex-delim-toggle-modifier)', '[T]oggle [D]elimiter \\left\\right')
    map('n', 'tsD', '<plug>(vimtex-delim-toggle-modifier-reverse)', '[T]oggle [D]elimiter reverse')
    map('n', 'tsf', '<plug>(vimtex-cmd-toggle-frac)', '[T]oggle [F]raction')
    map('x', 'tsf', '<plug>(vimtex-cmd-toggle-frac)', '[T]oggle [F]raction')

    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ INSERT MODE                                                             │
    -- └─────────────────────────────────────────────────────────────────────────┘
    map('i', ']]', '<plug>(vimtex-delim-close)', 'Close delimiter')
end

return {
    'lervag/vimtex',
    lazy = false, -- VimTeX must not be lazy loaded (breaks inverse search)
    init = function()
        -- Disable VimTeX's default mappings (we define our own above)
        vim.g.vimtex_mappings_enabled = 0
        vim.g.vimtex_imaps_enabled = 0

        -- Viewer configuration
        vim.g.vimtex_view_method = 'zathura'

        -- Quickfix settings
        vim.g.vimtex_quickfix_mode = 0 -- Don't open quickfix automatically

        -- Conceal settings (hide LaTeX markup for cleaner view)
        vim.g.vimtex_syntax_conceal = {
            accents = 1,
            ligatures = 1,
            cites = 1,
            fancy = 1,
            spacing = 1,
            greek = 1,
            math_bounds = 1,
            math_delimiters = 1,
            math_fracs = 1,
            math_super_sub = 1,
            math_symbols = 1,
            sections = 0,
            styles = 1,
        }

        -- TOC settings
        vim.g.vimtex_toc_config = {
            split_pos = 'vert leftabove',
            split_width = 40,
            mode = 2,
            fold_enable = 1,
            show_help = 0,
            hotkeys_enabled = 1,
            hotkeys_leader = '',
        }
    end,
    config = function()
        vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'tex', 'latex' },
            callback = function()
                keymaps()
            end,
        })
    end,
}
