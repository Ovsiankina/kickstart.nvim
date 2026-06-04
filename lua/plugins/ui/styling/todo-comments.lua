-- Highlight todo, notes, etc in comments

-- TEST BLOCK — visual verification of all keywords
-- TODO: uppercase plain
-- TODO(non-blocking): uppercase with decorator
-- todo: lowercase plain
-- todo(non-blocking): lowercase with decorator
--
-- CHORE: uppercase plain
-- CHORE(non-blocking): uppercase with decorator
-- chore: lowercase plain
-- chore(non-blocking): lowercase with decorator
--
-- ISSUE: uppercase plain
-- ISSUE(blocking): uppercase with decorator
-- issue: lowercase plain
-- issue(blocking): lowercase with decorator
--
-- QUESTION: uppercase plain
-- QUESTION(if-minor): uppercase with decorator
-- question: lowercase plain
-- question(if-minor): lowercase with decorator
--
-- NOTE: uppercase plain
-- NOTE(non-blocking): uppercase with decorator
-- note: lowercase plain
-- note(non-blocking): lowercase with decorator
--
-- THOUGHT: uppercase plain
-- THOUGHT(non-blocking): uppercase with decorator
-- thought: lowercase plain
-- thought(non-blocking): lowercase with decorator
--
-- INFO: uppercase plain
-- INFO(non-blocking): uppercase with decorator
-- info: lowercase plain
-- info(non-blocking): lowercase with decorator
--
-- DOC: uppercase plain
-- DOC(non-blocking): uppercase with decorator
-- doc: lowercase plain
-- doc(non-blocking): lowercase with decorator
--
-- PRAISE: uppercase plain
-- PRAISE(non-blocking): uppercase with decorator
-- praise: lowercase plain
-- praise(non-blocking): lowercase with decorator
--
-- SUGGESTION: uppercase plain
-- SUGGESTION(non-blocking): uppercase with decorator
-- suggestion: lowercase plain
-- suggestion(non-blocking): lowercase with decorator
--
-- NITPICK: uppercase plain
-- NITPICK(non-blocking): uppercase with decorator
-- nitpick: lowercase plain
-- nitpick(non-blocking): lowercase with decorator
--
-- QUIBBLE: uppercase plain
-- QUIBBLE(if-minor): uppercase with decorator
-- quibble: lowercase plain
-- quibble(if-minor): lowercase with decorator
--
-- POLISH: uppercase plain
-- POLISH(non-blocking): uppercase with decorator
-- polish: lowercase plain
-- polish(non-blocking): lowercase with decorator
--
-- TYPO: uppercase plain
-- TYPO(non-blocking): uppercase with decorator
-- typo: lowercase plain
-- typo(non-blocking): lowercase with decorator
--
-- BLOCKING: uppercase plain
-- BLOCKING(blocking): uppercase with decorator
-- blocking: lowercase plain
-- blocking(blocking): lowercase with decorator
--
-- NON-BLOCKING: uppercase plain
-- NON-BLOCKING(non-blocking): uppercase with decorator
-- non-blocking: lowercase plain
-- non-blocking(non-blocking): lowercase with decorator
--
-- IF-MINOR: uppercase plain
-- IF-MINOR(if-minor): uppercase with decorator
-- if-minor: lowercase plain
-- if-minor(if-minor): lowercase with decorator
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

        keywords = {
            TODO = {
                color = 'info',
                alt = { 'todo', 'CHORE', 'chore' },
            },
            ISSUE = {
                color = 'error',
                alt = { 'issue' },
            },
            QUESTION = {
                color = 'warning',
                alt = { 'question' },
            },
            NOTE = {
                color = 'hint',
                alt = { 'note', 'THOUGHT', 'thought', 'INFO', 'info', 'DOC', 'doc' },
            },
            PRAISE = {
                color = 'hint',
                alt = { 'praise' },
            },
            SUGGESTION = {
                color = 'warning',
                alt = { 'suggestion', 'NITPICK', 'nitpick', 'QUIBBLE', 'quibble', 'POLISH', 'polish' },
            },
            TYPO = {
                color = 'warning',
                alt = { 'typo' },
            },
            BLOCKING = {
                color = 'error',
                alt = { 'blocking' },
            },
            ['NON-BLOCKING'] = {
                color = 'hint',
                alt = { 'non-blocking' },
            },
            ['IF-MINOR'] = {
                color = 'hint',
                alt = { 'if-minor' },
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
