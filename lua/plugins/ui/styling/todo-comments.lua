-- Highlight todo, notes, etc in comments
local keymaps = function()
    vim.keymap.set(
        'n',
        '<leader>fc',
        ':TodoTelescope<CR>',
        { desc = 'Find [c]omments' }
    )
end
keymaps()

return {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    opts = {
        signs = false,

        merge_keywords = true, -- when true, custom keywords will be merged with the defaults

        highlight = {
            pattern = [[.*<(%(KEYWORDS)%(\(.{-1,}\))?):]],
        },

        search = {
            -- regex that will be used to match keywords.
            -- don't replace the (KEYWORDS) placeholder
            pattern = [[\b(KEYWORDS)\b\s*(\([^)]*\))?\s*:]], -- ripgrep regex
        },

        -- TODO: add icons and the other keywords + i dont like TODO to be in
        -- green. It's too hard to read near strings that are also the same
        -- green
        keywords = {
            TODO = {
                color = 'info',
                alt = {
                    'TODO',
                    'CHORE',
                    'TYPO',
                    'todo',
                    'chore',
                    'typo',
                },
            },
            -- NOTE:
            NOTE = {
                -- icon = icons.note,
                color = 'hint',
                alt = {
                    'DOC',
                    'doc',
                    'INFO',
                    'PRAISE',
                    'NITPICK',
                    'SUGGESTION',
                    'QUESTION',
                    'THOUGHT',
                    'NOTE',
                    'info',
                    'praise',
                    'nitpick',
                    'suggestion',
                    'question',
                    'thought',
                    'note',
                },
            },
        },
    },
    config = function(_, opts)
        require('todo-comments').setup(opts)
        -- Override the keywords table metatable so that if a match
        -- returns extra characters (e.g. "TODO 2" or "NOTE(foo)"), only the
        -- base keyword (the initial word) is used to look up highlighting info.
        local cfg = require 'todo-comments.config'
        setmetatable(cfg.keywords, {
            __index = function(t, k)
                local base = vim.fn.matchstr(k, [[^\w\+]])
                if base == '' then
                    return nil
                else
                    return rawget(t, base)
                end
            end,
        })
    end,
}
