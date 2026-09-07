-- File name: herdr-splits.lua
-- herdr <-> neovim seamless Ctrl+hjkl navigation (vim-tmux-navigator style).
-- Only loads inside a herdr pane (HERDR_ENV=1), so tmux/kitty keep using
-- smart-splits.nvim untouched. Pairs with the `herdr-splits` herdr plugin
-- (herdr plugin install lmilojevicc/herdr-splits.nvim) + the ctrl+hjkl
-- [[keys.command]] binds in ~/.config/herdr/config.toml.
-- Resize is intentionally left to herdr (Alt+Shift+hjkl); no resize keymaps here.

return {
    'lmilojevicc/herdr-splits.nvim',
    cond = vim.env.HERDR_ENV == '1',
    event = 'VeryLazy',
    config = function()
        require('herdr-splits').setup {
            at_edge = 'wrap',
        }
    end,
    keys = {
        {
            '<C-h>',
            function()
                require('herdr-splits').move_cursor_left()
            end,
            desc = 'herdr: focus split/pane left',
        },
        {
            '<C-j>',
            function()
                require('herdr-splits').move_cursor_down()
            end,
            desc = 'herdr: focus split/pane down',
        },
        {
            '<C-k>',
            function()
                require('herdr-splits').move_cursor_up()
            end,
            desc = 'herdr: focus split/pane up',
        },
        {
            '<C-l>',
            function()
                require('herdr-splits').move_cursor_right()
            end,
            desc = 'herdr: focus split/pane right',
        },
    },
}
