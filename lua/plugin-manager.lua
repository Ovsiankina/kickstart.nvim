local M = {}

M.install = function()
    -- [[ Install `lazy.nvim` plugin manager ]]
    --    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
    local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
        local out = vim.fn.system {
            'git',
            'clone',
            '--filter=blob:none',
            '--branch=stable',
            lazyrepo,
            lazypath,
        }
        if vim.v.shell_error ~= 0 then
            error('Error cloning lazy.nvim:\n' .. out)
        end
    end

    ---@type vim.Option
    local rtp = vim.opt.rtp
    rtp:prepend(lazypath)
end

M.plugins = function()
    -- [[ Configure and install plugins ]]
    require('lazy').setup(M.imports, {
        ui = {
            -- If you are using a Nerd Font: set icons to an empty table which will use the
            -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
            icons = vim.g.have_nerd_font and {} or M.icons,
        },
    })
end

M.imports = {
    -- [[ Grouped plugins ]]

    -- [[ Text-editing ]]
    -- Plugins that makes the writting part of coding much more pleasant ! Think blink, mini, indentation, autopairs, etc.
    { import = 'plugins.text-editing' },

    -- [[ General workflow ]]
    -- Plugins that helps your workflow.
    -- Think file navigation with Telescope !
    { import = 'plugins.workflow' },

    -- [[ IDE tooling ]]
    -- Plugins all arond powerful IDE tooling such as LSPs, DAPs, linters and formatters
    --
    -- 'IDE-tooling' is named after how `mason.nvim` describes what it handles i.e: external editor tooling such as LSP servers, DAP servers, linters, and formatters
    -- WARN: Do not import 'plugins.ide'. This will return the 'plugin.ide.tooling' tables !
    { import = 'plugins.ide.lsp' },
    { import = 'plugins.ide.dap' },
    { import = 'plugins.ide.lint' },
    { import = 'plugins.ide.fmt' },
    { import = 'plugins.ide.parser' },

    -- [[ UI plugins ]]
    -- UI plugins regroup everything that adds styling to new modules in the editor environment.
    -- Think oil.nvim or git-signs.
    { import = 'plugins.ui' },
    { import = 'plugins.ui.file_explorer' },
    { import = 'plugins.ui.git' },
    { import = 'plugins.ui.statusline' },
    { import = 'plugins.ui.styling' },
}

--  [[ Language specific plugins ]]
--  Plugins that aims a specific language or set of languages.
local langs = require 'settings.enabled-languages'
if langs.lua then
    table.insert(M.imports, { import = 'plugins.languages.lua' })
end

if langs.rust then
    table.insert(M.imports, { import = 'plugins.languages.rust' })
end

M.icons = {
    cmd = '⌘',
    config = '🛠',
    event = '📅',
    ft = '📂',
    init = '⚙',
    keys = '🗝',
    plugin = '🔌',
    runtime = '💻',
    require = '🌙',
    source = '📄',
    start = '🚀',
    task = '📌',
    lazy = '💤 ',
}

return M
-- vim: ts=2 sts=2 sw=2 et
